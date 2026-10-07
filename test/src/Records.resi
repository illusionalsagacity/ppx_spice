@spice
type t = {
  label: string,
  value: int,
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

let t5_string_encode: t5<string> => Js.Json.t
let t5_string_decode: Js.Json.t => Spice.result<t5<string>>

@spice
type t6<'key, 'value> = {
  key: 'key,
  value: 'value,
}

let t6_string_int_encode: t6<string, int> => Js.Json.t
let t6_string_int_decode: Js.Json.t => Spice.result<t6<string, int>>

// Generic record using every container codec; the .resi match checks codec arity
@spice
type t7<'a> = {
  l: list<'a>,
  o: option<'a>,
  d: Js.Dict.t<'a>,
  r: Belt.Result.t<'a, string>,
}

@spice
type withNull = {
  o: option<string>,
  n: Js.Null.t<string>,
  n2: Js.null<int>,
}
