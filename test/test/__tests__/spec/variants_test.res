open Zora

let testEqual = (t, name, lhs, rhs) =>
  t->test(name, async t => {
    t->equal(lhs, rhs, name)
  })

zoraBlock("variants with @spice.as", t => {
  let variantEncoded = Variants.One->Variants.t_encode
  t->testEqual(`encode 하나`, variantEncoded, Js.Json.number(1.))

  let variantEncoded = Variants.Two->Variants.t_encode
  t->testEqual(`encode 둘`, variantEncoded, Js.Json.string(`둘`))

  let variantDecoded = Js.Json.number(1.)->Variants.t_decode
  t->testEqual(`decode 하나`, variantDecoded, Ok(Variants.One))

  let variantDecoded = Js.Json.string(`둘`)->Variants.t_decode
  t->testEqual(`decode 둘`, variantDecoded, Ok(Variants.Two))
})

zoraBlock(`variants without @spice.as`, t => {
  let variantEncoded = Variants.One1->Variants.t1_encode
  t->testEqual(`encode One1`, variantEncoded, Js.Json.array([Js.Json.string(`One1`)]))

  let variantEncoded = Variants.Two1->Variants.t1_encode
  t->testEqual(`encode Two1`, variantEncoded, Js.Json.array([Js.Json.string(`Two1`)]))

  let variantDecoded = Js.Json.array([Js.Json.string(`One1`)])->Variants.t1_decode
  t->testEqual(`decode ["One1"]`, variantDecoded, Ok(Variants.One1))

  let variantDecoded = Js.Json.array([Js.Json.string(`Two1`)])->Variants.t1_decode
  t->testEqual(`decode ["Two1"]`, variantDecoded, Ok(Variants.Two1))
})

zoraBlock("unboxed variants with @spice.as", t => {
  let variantEncoded = Variants.One2(0)->Variants.t2_encode
  t->testEqual(`encode 하나`, variantEncoded, Js.Json.number(0.0))

  let variantDecoded = Js.Json.number(0.0)->Variants.t2_decode
  t->testEqual(`decode 하나`, variantDecoded, Ok(Variants.One2(0)))
})

zoraBlock(`unboxed variants without @spice.as`, t => {
  let variantEncoded = Variants.One3(0)->Variants.t3_encode
  t->testEqual(`encode One3(0)`, variantEncoded, Js.Json.number(0.0))

  let variantDecoded = Js.Json.number(0.0)->Variants.t3_decode
  t->testEqual(`decode 0`, variantDecoded, Ok(Variants.One3(0)))
})

zoraBlock("variants with @spice.as number", t => {
  let variantEncoded = Variants.One->Variants.t4_encode
  t->testEqual(`encode 1.0`, variantEncoded, Js.Json.number(1.0))

  let variantEncoded = Variants.Two->Variants.t4_encode
  t->testEqual(`encode 2.0`, variantEncoded, Js.Json.number(2.0))

  let variantDecoded = Js.Json.number(1.0)->Variants.t4_decode
  t->testEqual(`decode 1.0`, variantDecoded, Ok(Variants.One))

  let variantDecoded = Js.Json.number(2.0)->Variants.t4_decode
  t->testEqual(`decode 2.0`, variantDecoded, Ok(Variants.Two))
})

zoraBlock("variant error path includes correct index", t => {
  // Variant with args: ["WithArgs", int, string]
  // Index 0 is the constructor name, so the first argument is at index 1
  let invalidJson = Js.Json.array([
    Js.Json.string("WithArgs"),
    Js.Json.string("not an int"),
    Js.Json.string("valid string"),
  ])

  let decoded = invalidJson->Variants.withArgs_decode
  t->test("error path shows [1] for first argument", async t => {
    switch decoded {
    | Error({path}) => t->equal(path, "[1]", "path should be [1]")
    | Ok(_) => t->fail("expected decode to fail")
    }
  })
})

zoraBlock("generic variant with single type parameter", t => {
  let someEncoded = Variants.Some("hello")->Variants.t5_string_encode
  t->testEqual(
    `encode Some("hello")`,
    someEncoded,
    Js.Json.array([Js.Json.string("Some"), Js.Json.string("hello")]),
  )

  let noneEncoded = Variants.None->Variants.t5_string_encode
  t->testEqual(`encode None`, noneEncoded, Js.Json.array([Js.Json.string("None")]))

  let someDecoded =
    Js.Json.array([Js.Json.string("Some"), Js.Json.string("hello")])->Variants.t5_string_decode
  t->testEqual(`decode Some`, someDecoded, Ok(Variants.Some("hello")))

  let noneDecoded = Js.Json.array([Js.Json.string("None")])->Variants.t5_string_decode
  t->testEqual(`decode None`, noneDecoded, Ok(Variants.None))
})

zoraBlock("generic variant with multiple type parameters", t => {
  let leftEncoded = Variants.Left("hello")->Variants.t6_string_int_encode
  t->testEqual(
    `encode Left("hello")`,
    leftEncoded,
    Js.Json.array([Js.Json.string("Left"), Js.Json.string("hello")]),
  )

  let rightEncoded = Variants.Right(42)->Variants.t6_string_int_encode
  t->testEqual(
    `encode Right(42)`,
    rightEncoded,
    Js.Json.array([Js.Json.string("Right"), Js.Json.number(42.0)]),
  )

  let bothEncoded = Variants.Both("hello", 42)->Variants.t6_string_int_encode
  t->testEqual(
    `encode Both("hello", 42)`,
    bothEncoded,
    Js.Json.array([Js.Json.string("Both"), Js.Json.string("hello"), Js.Json.number(42.0)]),
  )

  let leftDecoded =
    Js.Json.array([Js.Json.string("Left"), Js.Json.string("hello")])->Variants.t6_string_int_decode
  t->testEqual(`decode Left`, leftDecoded, Ok(Variants.Left("hello")))

  let rightDecoded =
    Js.Json.array([Js.Json.string("Right"), Js.Json.number(42.0)])->Variants.t6_string_int_decode
  t->testEqual(`decode Right`, rightDecoded, Ok(Variants.Right(42)))

  let bothDecoded =
    Js.Json.array([
      Js.Json.string("Both"),
      Js.Json.string("hello"),
      Js.Json.number(42.0),
    ])->Variants.t6_string_int_decode
  t->testEqual(`decode Both`, bothDecoded, Ok(Variants.Both("hello", 42)))
})
