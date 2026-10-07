# CHANGELOG

## 0.2.11 (unreleased)

A ReScript 11 line based on upstream 0.2.1, with later bug fixes ported. It does not include
upstream 0.2.2's breaking change to option encoding: `None` still encodes as `null`.

- BREAKING: Drop curried mode. `-uncurried` is still accepted but has no effect.
- Support `Js.Null.t` / `Js.null` / `Null.t`
- Fix error path index for variant and polyvariant arguments (`[1]` for the first argument, not `[0]`)
- Fix arity of codecs for generic types with a `.resi`, including generic records with array or list fields ([#105](https://github.com/mununki/ppx_spice/issues/105))
- Decode arrays without copying the accumulator for every element
- Ship native binaries for Linux arm64 and macOS arm64 alongside x64
- Build with OCaml 4.14 and ppxlib 0.28

## 0.2.1

- a190663 Utilize Js.Json.Boolean(bool) instead oif Js.Json.True, False https://github.com/green-labs/ppx_spice/pull/58
- a190663 Add support of uncurried mode for interface(*.resi) https://github.com/green-labs/ppx_spice/pull/58
- Support the compiler v11-rc.5 https://github.com/green-labs/ppx_spice/pull/61
- Add the feature of encoding/decoding between the number and (polymorphic)variant with `@spice.as` https://github.com/green-labs/ppx_spice/pull/64
- Fix generating encode, decode function when `@spice.as` with number https://github.com/green-labs/ppx_spice/pull/74

## 0.2.0

### Minor Changes

- 9ce55bf: Compat the untagged variant

## 0.2.0-next.0

### Minor Changes

- Compat the untagged variant

## 0.1.15

### Patch Changes

- 0e738ef: Support cli arg for uncurried mode

## 0.1.15-next.0

### Patch Changes

- Support cli arg for uncurried mode

# 0.1.14

- Support both `ns.optional` and `res.optional` for backward compatability

# 0.1.13

- Rename the attribute used for optional records from `ns.optional` to `res.optional`.

# 0.1.12

- Fix build error where `@spice.encode`, `@spice.decode` are used

# 0.1.11

- Build the executable with static linking for Linux with musl

# 0.1.10

- Build the executable with static linking for Linux

# 0.1.9

- Clean up npm publish files

# 0.1.8

- Fix type error where using tuple constructor type, such as `array<int>` for optional field in the record. https://github.com/green-labs/ppx_spice/pull/32

# 0.1.7

#### :rocket: New Feature

- Add support for the optional field record
- Add Windows platform support
