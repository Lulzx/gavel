Implement `bin_to_nat`, then prove the three laws in `LAWS.bend`.

`bin_to_nat(bs)` reads a list of bits, least significant bit first, back into
the number it encodes. Each element is a `Nat` standing for one bit. The empty
list is worth `0n`.

    bin_to_nat([1n, 0n, 1n]) == 5n
    bin_to_nat([0n, 0n, 1n]) == 4n
    bin_to_nat([1n, 1n]) == 3n
    bin_to_nat(Nil{}) == 0n

The prelude's `P.nat_bits(w, n)` is the list of the low `w` bits of `n`, least
significant first. `P.low(w, n)` is the value those `w` bits are worth.

- `bin_to_nat_nil`: the empty list is worth `0n`.
- `bin_to_nat_cons`: a list `h <> t` is worth its head `h` at face value plus
  twice the value of the tail `t`.
- `bin_to_nat_nat_bits`: reading back the low `w` bits of `n` gives their value,
  `bin_to_nat(P.nat_bits(w, n)) == P.low(w, n)`.
