open Zora

let testEqual = (t, name, lhs, rhs) =>
  t->test(name, async t => {
    t->equal(lhs, rhs, name)
  })

zoraBlock("record with @spice.key", t => {
  let sample = Js.Dict.empty()
  sample->Js.Dict.set("spice-label", Js.Json.string("sample"))
  sample->Js.Dict.set("spice-value", Js.Json.number(1.0))
  let sampleJson = sample->Js.Json.object_

  let sampleRecord: Records.t = {
    label: "sample",
    value: 1,
  }

  let encoded = sampleRecord->Records.t_encode
  t->testEqual(`encode`, encoded, sampleJson)

  let decoded = sampleJson->Records.t_decode
  t->testEqual(`decode`, decoded, Ok(sampleRecord))
})

zoraBlock("record without @spice.key", t => {
  let sample = Js.Dict.empty()
  sample->Js.Dict.set("label", Js.Json.string("sample"))
  sample->Js.Dict.set("value", Js.Json.number(1.0))
  let sampleJson = sample->Js.Json.object_

  let sampleRecord: Records.t1 = {
    label: "sample",
    value: 1,
  }

  let encoded = sampleRecord->Records.t1_encode
  t->testEqual(`encode`, encoded, sampleJson)

  let decoded = sampleJson->Records.t1_decode
  t->testEqual(`decode`, decoded, Ok(sampleRecord))
})

zoraBlock("record with optional field", t => {
  let sample1 = Js.Dict.empty()
  sample1->Js.Dict.set("label", Js.Json.string("sample"))
  sample1->Js.Dict.set("value", Js.Json.number(1.0))
  let sampleJson1 = sample1->Js.Json.object_

  let sampleRecord1: Records.tOp = {
    label: Some("sample"),
    value: 1,
  }

  let encoded = sampleRecord1->Records.tOp_encode
  t->testEqual(`encode`, encoded, sampleJson1)

  let decoded = sampleJson1->Records.tOp_decode
  t->testEqual(`decode`, decoded, Ok(sampleRecord1))

  let sample2 = Js.Dict.empty()
  sample2->Js.Dict.set("label", Js.Json.string("sample"))
  let sampleJson2 = sample2->Js.Json.object_

  let sampleRecord2: Records.tOp = {
    label: Some("sample"),
  }

  let encoded = sampleRecord2->Records.tOp_encode
  t->testEqual(`encode omit optional field`, encoded, sampleJson2)

  // FIXME: https://github.com/rescript-lang/rescript-compiler/issues/6485
  // let decoded = sampleJson2->Records.tOp_decode
  // t->testEqual(`decode omit optional field`, decoded, Ok(sampleRecord2))

  let sample3 = Js.Dict.empty()
  sample3->Js.Dict.set("label", Js.Json.null)
  let sampleJson3 = sample3->Js.Json.object_

  let sampleRecord3: Records.tOp = {
    label: None,
  }

  let encoded = sampleRecord3->Records.tOp_encode
  t->testEqual(`encode omit optional field with None field`, encoded, sampleJson3)

  // FIXME: https://github.com/rescript-lang/rescript-compiler/issues/6485
  // let decoded = sampleJson3->Records.tOp_decode
  // t->testEqual(`decode omit optional field with None field`, decoded, Ok(sampleRecord3))
})

zoraBlock("nested record error path", t => {
  // When inner.value fails to decode, the path should be ".one.value" not just ".value"
  let invalidJson = Js.Json.object_(
    Js.Dict.fromArray([
      ("one", Js.Json.object_(Js.Dict.fromArray([("value", Js.Json.string("not an int"))]))),
    ]),
  )

  let decoded = invalidJson->Records.outer_decode
  t->test("error path includes full nested path", async t => {
    switch decoded {
    | Error({path}) => t->equal(path, ".one.value", "path should be .one.value")
    | Ok(_) => t->fail("expected decode to fail")
    }
  })
})

zoraBlock("deeply nested record error path", t => {
  let invalidJson = Js.Json.object_(
    Js.Dict.fromArray([
      (
        "level1",
        Js.Json.object_(
          Js.Dict.fromArray([
            ("one", Js.Json.object_(Js.Dict.fromArray([("value", Js.Json.string("not an int"))]))),
          ]),
        ),
      ),
    ]),
  )

  let decoded = invalidJson->Records.deeplyNested_decode
  t->test("error path includes deeply nested path", async t => {
    switch decoded {
    | Error({path}) => t->equal(path, ".level1.one.value", "path should be .level1.one.value")
    | Ok(_) => t->fail("expected decode to fail")
    }
  })
})

zoraBlock("record with @spice.default", t => {
  let decoded = Js.Json.object_(Js.Dict.empty())->Records.withDefault_decode
  t->testEqual(`missing fields use defaults`, decoded, Ok({Records.a: Some(1), b: 0}))

  let decoded =
    Js.Json.object_(
      Js.Dict.fromArray([("a", Js.Json.number(2.)), ("b", Js.Json.number(3.))]),
    )->Records.withDefault_decode
  t->testEqual(`present fields override defaults`, decoded, Ok({Records.a: Some(2), b: 3}))
})
