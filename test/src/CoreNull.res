// @rescript/core exposes Js.Null.t as Null.t; the PPX matches that spelling too.
module Null = {
  type t<'a> = Js.Null.t<'a>
}

@spice
type t = {n: Null.t<string>}
