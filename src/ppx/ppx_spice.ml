open Ppxlib

class mapper =
  object (self)
    inherit Ast_traverse.map

    method! signature sign =
      sign |> List.map (Signature.map_signature_item self) |> List.concat

    method! structure strt =
      strt |> List.map (Structure.map_structure_item self) |> List.concat
  end

let signature_mapper = (new mapper)#signature
let structure_mapper = (new mapper)#structure

(* Only uncurried mode is supported. The flag is still accepted so existing
   rescript.json configs that pass it keep working. *)
let _ =
  Ppxlib.Driver.add_arg "-uncurried" (Arg.Unit ignore)
    ~doc:" No-op: uncurried mode is always on"

let _ =
  Ppxlib.Driver.register_transformation ~preprocess_impl:structure_mapper
    ~preprocess_intf:signature_mapper "spice"
