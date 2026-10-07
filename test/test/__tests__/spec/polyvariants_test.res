open Zora

let testEqual = (t, name, lhs, rhs) =>
  t->test(name, async t => {
    t->equal(lhs, rhs, name)
  })

zoraBlock("polymorphic variants with attribute", t => {
  let polyvariantEncoded = #one->Polyvariants.t_encode
  t->testEqual("encode 하나", polyvariantEncoded, Js.Json.string(`하나`))

  let polyvariantEncoded = #two->Polyvariants.t_encode
  t->testEqual("encode 둘", polyvariantEncoded, Js.Json.string(`둘`))

  let polyvariantDecoded = Js.Json.string(`하나`)->Polyvariants.t_decode
  t->testEqual("decode 하나", polyvariantDecoded, Ok(#one))

  let polyvariantDecoded = Js.Json.string(`둘`)->Polyvariants.t_decode
  t->testEqual("decode 둘", polyvariantDecoded, Ok(#two))
})

zoraBlock("polymorphic variants", t => {
  let polyvariantEncoded = #one->Polyvariants.t1_encode
  t->testEqual(`encode #one`, polyvariantEncoded, Js.Json.array([Js.Json.string(`one`)]))

  let polyvariantEncoded = #two->Polyvariants.t1_encode
  t->testEqual(`encode #two`, polyvariantEncoded, Js.Json.array([Js.Json.string(`two`)]))

  let polyvariantDecoded = Js.Json.array([Js.Json.string(`one`)])->Polyvariants.t1_decode
  t->testEqual(`decode one`, polyvariantDecoded, Ok(#one))

  let polyvariantDecoded = Js.Json.array([Js.Json.string(`two`)])->Polyvariants.t1_decode
  t->testEqual(`decode two`, polyvariantDecoded, Ok(#two))
})

zoraBlock("polymorphic variants with @spice.as number", t => {
  let polyvariantEncoded = #one->Polyvariants.t2_encode
  t->testEqual("encode 1.0", polyvariantEncoded, Js.Json.number(1.0))

  let polyvariantEncoded = #two->Polyvariants.t2_encode
  t->testEqual("encode 2.0", polyvariantEncoded, Js.Json.number(2.0))

  let polyvariantDecoded = Js.Json.number(1.0)->Polyvariants.t2_decode
  t->testEqual("decode 1.0", polyvariantDecoded, Ok(#one))

  let polyvariantDecoded = Js.Json.number(2.0)->Polyvariants.t2_decode
  t->testEqual("decode 2.0", polyvariantDecoded, Ok(#two))
})

zoraBlock("polyvariant error path includes correct index", t => {
  // Polyvariant with args: ["WithArgs", int, string]
  // Index 0 is the constructor name, so the first argument is at index 1
  let invalidJson = Js.Json.array([
    Js.Json.string("WithArgs"),
    Js.Json.string("not an int"),
    Js.Json.string("valid string"),
  ])

  let decoded = invalidJson->Polyvariants.withArgs_decode
  t->test("error path shows [1] for first argument", async t => {
    switch decoded {
    | Error({path}) => t->equal(path, "[1]", "path should be [1]")
    | Ok(_) => t->fail("expected decode to fail")
    }
  })
})
