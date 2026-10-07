open Zora

let testEqual = (t, name, lhs, rhs) =>
  t->test(name, async t => {
    t->equal(lhs, rhs, name)
  })

zoraBlock("array of strings", t => {
  let data = ["first", "second", "third", "fourth", "fifth"]
  let json = Js.Json.array([
    Js.Json.string("first"),
    Js.Json.string("second"),
    Js.Json.string("third"),
    Js.Json.string("fourth"),
    Js.Json.string("fifth"),
  ])

  let encoded = data->Arrays.stringArray_encode
  t->testEqual("encode string array", encoded, json)

  let decoded = json->Arrays.stringArray_decode
  t->testEqual("decode string array preserves order", decoded, Ok(data))
})

zoraBlock("array of ints", t => {
  let data = [1, 2, 3, 4, 5]
  let json = Js.Json.array([
    Js.Json.number(1.0),
    Js.Json.number(2.0),
    Js.Json.number(3.0),
    Js.Json.number(4.0),
    Js.Json.number(5.0),
  ])

  let encoded = data->Arrays.intArray_encode
  t->testEqual("encode int array", encoded, json)

  let decoded = json->Arrays.intArray_decode
  t->testEqual("decode int array preserves order", decoded, Ok(data))
})

zoraBlock("array of floats", t => {
  let data = [1.1, 2.2, 3.3, 4.4, 5.5]
  let json = Js.Json.array([
    Js.Json.number(1.1),
    Js.Json.number(2.2),
    Js.Json.number(3.3),
    Js.Json.number(4.4),
    Js.Json.number(5.5),
  ])

  let encoded = data->Arrays.floatArray_encode
  t->testEqual("encode float array", encoded, json)

  let decoded = json->Arrays.floatArray_decode
  t->testEqual("decode float array preserves order", decoded, Ok(data))
})

zoraBlock("array of bools", t => {
  let data = [true, false, true, false, true]
  let json = Js.Json.array([
    Js.Json.boolean(true),
    Js.Json.boolean(false),
    Js.Json.boolean(true),
    Js.Json.boolean(false),
    Js.Json.boolean(true),
  ])

  let encoded = data->Arrays.boolArray_encode
  t->testEqual("encode bool array", encoded, json)

  let decoded = json->Arrays.boolArray_decode
  t->testEqual("decode bool array preserves order", decoded, Ok(data))
})

zoraBlock("array of records", t => {
  let data: array<Arrays.recordItem> = [
    {id: 1, name: "first"},
    {id: 2, name: "second"},
    {id: 3, name: "third"},
  ]
  let json = Js.Json.array([
    Js.Json.object_(Js.Dict.fromArray([("id", Js.Json.number(1.0)), ("name", Js.Json.string("first"))])),
    Js.Json.object_(Js.Dict.fromArray([("id", Js.Json.number(2.0)), ("name", Js.Json.string("second"))])),
    Js.Json.object_(Js.Dict.fromArray([("id", Js.Json.number(3.0)), ("name", Js.Json.string("third"))])),
  ])

  let encoded = data->Arrays.recordArray_encode
  t->testEqual("encode record array", encoded, json)

  let decoded = json->Arrays.recordArray_decode
  t->testEqual("decode record array preserves order", decoded, Ok(data))
})

zoraBlock("nested arrays", t => {
  let data = [[1, 2], [3, 4], [5, 6]]
  let json = Js.Json.array([
    Js.Json.array([Js.Json.number(1.0), Js.Json.number(2.0)]),
    Js.Json.array([Js.Json.number(3.0), Js.Json.number(4.0)]),
    Js.Json.array([Js.Json.number(5.0), Js.Json.number(6.0)]),
  ])

  let encoded = data->Arrays.nestedArray_encode
  t->testEqual("encode nested array", encoded, json)

  let decoded = json->Arrays.nestedArray_decode
  t->testEqual("decode nested array preserves order", decoded, Ok(data))
})

zoraBlock("empty array", t => {
  let data: array<string> = []
  let json = Js.Json.array([])

  let encoded = data->Arrays.stringArray_encode
  t->testEqual("encode empty array", encoded, json)

  let decoded = json->Arrays.stringArray_decode
  t->testEqual("decode empty array", decoded, Ok(data))
})

zoraBlock("single element array", t => {
  let data = ["only"]
  let json = Js.Json.array([Js.Json.string("only")])

  let encoded = data->Arrays.stringArray_encode
  t->testEqual("encode single element array", encoded, json)

  let decoded = json->Arrays.stringArray_decode
  t->testEqual("decode single element array", decoded, Ok(data))
})
