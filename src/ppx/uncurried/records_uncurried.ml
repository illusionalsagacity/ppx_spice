open Ppxlib
open Parsetree
open Ast_helper
open Utils

type parsed_decl = {
  name : string;
  (* "NAME" *)
  key : expression;
  (* v.NAME *)
  field : expression;
  codecs : expression option * expression option;
  default : expression option;
  is_optional : bool;
}

let generate_encoder decls unboxed =
  match unboxed with
  | true ->
      let { codecs; field } = List.hd decls in
      let e, _ = codecs in
      Utils.expr_func ~arity:1 [%expr fun v -> [%e Option.get e] [%e field]]
  | false ->
      let arrExpr =
        decls
        |> List.map (fun { key; field; codecs = encoder, _; is_optional } ->
               let is_optional =
                 if is_optional then [%expr true] else [%expr false]
               in
               [%expr
                 [%e key],
                   [%e is_optional],
                   ([%e Option.get encoder] [%e field] [@res.uapp])])
        |> Exp.array
      in
      Exp.constraint_
        [%expr
          Js.Json.Object
            (Js.Dict.fromArray
               (Spice.filterOptional [%e arrExpr] [@res.uapp]) [@res.uapp])]
        Utils.ctyp_json_t
      |> Exp.fun_ Asttypes.Nolabel None [%pat? v]
      |> Utils.expr_func ~arity:1

let generate_dict_get { key; codecs = _, decoder; default } =
  let decoder = Option.get decoder in
  match default with
  | Some default ->
      [%expr
        Belt.Option.getWithDefault
          (Belt.Option.map (Js.Dict.get dict [%e key]) [%e decoder])
          (Ok [%e default]) [@res.uapp]]
  | None ->
      [%expr
        [%e decoder]
          (Belt.Option.getWithDefault
             (Js.Dict.get dict [%e key] [@res.uapp])
             Js.Json.null [@res.uapp]) [@res.uapp]]

let generate_error_case { key } =
  {
    pc_lhs = [%pat? Error (e : Spice.decodeError)];
    pc_guard = None;
    pc_rhs = [%expr Error { e with path = "." ^ [%e key] ^ e.path }];
  }

let generate_final_record_expr decls =
  decls
  |> List.map (fun { name; is_optional } ->
         let attrs = if is_optional then [ Utils.attr_optional ] else [] in
         (lid name, make_ident_expr ~attrs name))
  |> fun l -> [%expr Ok [%e Exp.record l None]]

let generate_success_case { name } success_expr =
  {
    pc_lhs = (mknoloc name |> Pat.var |> fun p -> [%pat? Ok [%p p]]);
    pc_guard = None;
    pc_rhs = success_expr;
  }

let generate_nested_switches decls =
  let rec loop current_expr = function
    | [] -> current_expr
    | decl :: rest ->
        let success_case = generate_success_case decl current_expr in
        let error_case = generate_error_case decl in
        let match_expr =
          Exp.match_ (generate_dict_get decl) [ success_case; error_case ]
        in
        loop match_expr rest
  in
  loop (generate_final_record_expr decls) (List.rev decls)

let generate_decoder decls unboxed =
  match unboxed with
  | true ->
      let { codecs; name } = List.hd decls in
      let _, d = codecs in

      let record_expr = Exp.record [ (lid name, make_ident_expr "v") ] None in

      Utils.expr_func ~arity:1
        [%expr
          fun v ->
            Belt.Result.map ([%e Option.get d] v) (fun v -> [%e record_expr])]
  | false ->
      Utils.expr_func ~arity:1
        [%expr
          fun v ->
            match (v : Js.Json.t) with
            | Js.Json.Object dict -> [%e generate_nested_switches decls]
            | _ -> Spice.error "Not an object" v [@res.uapp]]

let parse_decl generator_settings
    { pld_name = { txt }; pld_loc = _; pld_type; pld_attributes } =
  let default, key, is_optional =
    List.fold_left
      (fun (default, key, is_optional) ({ attr_name = { txt = name } } as attr)
      ->
        match name with
        | "spice.default" ->
            (Some (get_expression_from_payload attr), key, is_optional)
        | "spice.key" ->
            (default, Some (get_expression_from_payload attr), is_optional)
        | "ns.optional" | "res.optional" -> (default, key, true)
        | _ -> (default, key, is_optional))
      (None, None, false) pld_attributes
  in
  let key =
    match key with
    | Some k -> k
    | None -> Exp.constant (Pconst_string (txt, Location.none, None))
  in
  let codecs = Codecs.generate_codecs generator_settings pld_type in
  let add_attrs attrs e = { e with pexp_attributes = attrs } in
  let codecs =
    if is_optional then
      match codecs with
      | Some encode, Some decode ->
          ( Some
              (add_attrs
                 [ Utils.attr_partial; Utils.attr_uapp ]
                 [%expr Spice.optionToJson [%e encode]]),
            Some
              (add_attrs
                 [ Utils.attr_partial; Utils.attr_uapp ]
                 [%expr Spice.optionFromJson [%e decode]]) )
      | Some encode, _ ->
          ( Some
              (add_attrs
                 [ Utils.attr_partial; Utils.attr_uapp ]
                 [%expr Spice.optionToJson [%e encode]]),
            None )
      | _, Some decode ->
          ( None,
            Some
              (add_attrs
                 [ Utils.attr_partial; Utils.attr_uapp ]
                 [%expr Spice.optionFromJson [%e decode]]) )
      | None, None -> codecs
    else codecs
  in

  {
    name = txt;
    key;
    field = Exp.field [%expr v] (lid txt);
    codecs;
    default;
    is_optional;
  }

let generate_codecs ({ do_encode; do_decode } as generator_settings) decls
    unboxed =
  let parsed_decls = List.map (parse_decl generator_settings) decls in
  ( (if do_encode then Some (generate_encoder parsed_decls unboxed) else None),
    if do_decode then Some (generate_decoder parsed_decls unboxed) else None )
