@spice
type t = {
  @spice.key("spice-label") label: string,
  @spice.key("spice-value") value: int,
}

@spice
type t1 = {
  label: string,
  value: int,
}

@spice
type tOp = {
  label: option<string>,
  value?: int,
}

// let de = v =>
//   switch (v: Js.Json.t) {
//   | Js.Json.Object(dict) =>
//     switch (Spice.optionFromJson(Spice.stringFromJson, ...))(
//       Belt.Option.getWithDefault(Js.Dict.get(dict, "label"), Js.Json.null),
//     ) {
//     | Ok(label) =>
//       switch (Spice.optionFromJson(Spice.intFromJson, ...))(
//         Belt.Option.getWithDefault(Js.Dict.get(dict, "value"), Js.Json.null),
//       ) {
//       | Ok(value) => Ok({label, value: ?value})
//       | Error(e: Spice.decodeError) => Error(e)
//       }
//     | Error(e: Spice.decodeError) => Error(e)
//     }
//   | _ => Spice.error("", v)
//   }

// Types for testing nested error paths
@spice.decode
type inner = {value: int}

@spice.decode
type outer = {one: inner}

@spice.decode
type deeplyNested = {level1: outer}

@spice
type withDefault = {
  @spice.default(Some(1)) opt: option<int>,
  @spice.default(0) num: int,
}

@spice
type t5<'data> = {a: array<'data>}

let t5_string_encode = t5_encode(Spice.stringToJson)
let t5_string_decode = t5_decode(Spice.stringFromJson)

@spice
type t6<'key, 'value> = {
  key: 'key,
  value: 'value,
}

let t6_string_int_encode = t6_encode(Spice.stringToJson, Spice.intToJson)
let t6_string_int_decode = t6_decode(Spice.stringFromJson, Spice.intFromJson)

// Generic record using every container codec; the .resi match checks codec arity
@spice
type t7<'a> = {
  l: list<'a>,
  o: option<'a>,
  d: Js.Dict.t<'a>,
  r: Belt.Result.t<'a, string>,
}
