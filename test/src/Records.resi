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
  @spice.default(Some(1)) a: option<int>,
  @spice.default(0) b: int,
}
