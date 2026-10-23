Implement `inc_bin`, then prove the three laws in `LAWS.bend`.

A natural number is written here as a `List<&2, P.Bit>` of bits `P.O{}` and
`P.I{}`, least significant bit first; the empty list is zero. `inc_bin(bs)` is
the bit list for one more than the number `bs` denotes. A low `P.O{}` becomes
`P.I{}` with the rest unchanged; a low `P.I{}` becomes `P.O{}` with the carry
going into the higher bits; and the empty list becomes the one-bit list
`P.I{} <> Nil{}`:

    inc_bin([P.O{}, P.I{}]) == [P.I{}, P.I{}]
    inc_bin([P.I{}, P.I{}]) == [P.O{}, P.O{}, P.I{}]
    inc_bin(Nil{}) == [P.I{}]

The laws use the prelude's `P.to_nat(bs)`, the `Nat` a bit list denotes (each
bit's value `P.bit_val` plus twice the value of the higher bits, with
`P.double(n)` being `n + n`).

- `inc_bin_nil`: the empty list increments to `P.I{} <> Nil{}`.
- `inc_bin_zero`: `P.O{} <> t` increments to `P.I{} <> t`.
- `to_nat_inc`: the number `inc_bin(bs)` denotes is one more than the number
  `bs` denotes.
