// This file contains NO @spice annotations
// It tests that the early-exit optimization correctly skips transformation
// for files without any spice attributes

type regularUser = {
  id: int,
  name: string,
  email: string,
}

type regularAddress = {
  street: string,
  city: string,
  state: string,
  zip: string,
}

type regularStatus =
  | Active
  | Inactive
  | Pending

type regularColor = [
  | #Red
  | #Green
  | #Blue
]

type nestedRegular = {
  user: regularUser,
  address: regularAddress,
  status: regularStatus,
}

let createUser = (id, name, email) => {id, name, email}

let getUserName = user => user.name

let isActive = status =>
  switch status {
  | Active => true
  | _ => false
  }

let colorToString = color =>
  switch color {
  | #Red => "red"
  | #Green => "green"
  | #Blue => "blue"
  }

// More types to increase file size
type item1 = {value: string}
type item2 = {value: int}
type item3 = {value: float}
type item4 = {value: bool}
type item5 = {value: option<string>}
type item6 = {value: array<int>}
type item7 = {value: list<string>}
type item8 = {a: string, b: int}
type item9 = {a: string, b: int, c: float}
type item10 = {a: string, b: int, c: float, d: bool}

type variant1 = A | B | C
type variant2 = X | Y | Z
type variant3 = One | Two | Three
type variant4 = First | Second | Third
type variant5 = Alpha | Beta | Gamma

type poly1 = [#A | #B | #C]
type poly2 = [#X | #Y | #Z]
type poly3 = [#One | #Two | #Three]
type poly4 = [#First | #Second | #Third]
type poly5 = [#Alpha | #Beta | #Gamma]

// Generic types
type wrapper<'a> = {data: 'a}
type container<'a, 'b> = {first: 'a, second: 'b}
type triple<'a, 'b, 'c> = {a: 'a, b: 'b, c: 'c}

// Tuples
type pair = (int, string)
type triple2 = (int, string, bool)
type quad = (int, string, bool, float)
