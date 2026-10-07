open Zora

let testEqual = (t, name, lhs, rhs) =>
  t->test(name, async t => {
    t->equal(lhs, rhs, name)
  })

zoraBlock("top-level option", t => {
  t->testEqual(`encode None`, None->Options.topLevel_encode, Js.Json.null)
  t->testEqual(`encode Some`, Some(1)->Options.topLevel_encode, Js.Json.number(1.))
  t->testEqual(`decode null`, Js.Json.null->Options.topLevel_decode, Ok(None))
  t->testEqual(`decode value`, Js.Json.number(1.)->Options.topLevel_decode, Ok(Some(1)))
})

zoraBlock("option in array", t => {
  let json = Js.Json.array([Js.Json.number(1.), Js.Json.null])
  t->testEqual(`encode`, [Some(1), None]->Options.inArray_encode, json)
  t->testEqual(`decode`, json->Options.inArray_decode, Ok([Some(1), None]))
})

zoraBlock("option in tuple", t => {
  let json = Js.Json.array([Js.Json.null, Js.Json.string("a")])
  t->testEqual(`encode`, (None, "a")->Options.inTuple_encode, json)
  t->testEqual(`decode`, json->Options.inTuple_decode, Ok((None, "a")))
})

zoraBlock("option in variant", t => {
  let json = Js.Json.array([Js.Json.string("Wrap"), Js.Json.null])
  t->testEqual(`encode`, Options.Wrap(None)->Options.inVariant_encode, json)
  t->testEqual(`decode`, json->Options.inVariant_decode, Ok(Options.Wrap(None)))
})
