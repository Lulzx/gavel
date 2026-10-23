Implement `nat_bits`, then prove the three laws in `LAWS.bend`.

`nat_bits(w, n)` is the list of the low `w` bits of `n`, least significant bit
first, each bit a `Nat` that is `0n` or `1n`. It has exactly `w` elements, and
a number too small to fill the width is padded with `0n`.

    nat_bits(4n, 6n) == [0n, 1n, 1n, 0n]
    nat_bits(2n, 7n) == [1n, 1n]
    nat_bits(3n, 0n) == [0n, 0n, 0n]
    nat_bits(0n, 7n) == Nil{}

The laws use `P.len(bs)`, the number of elements of a list.

- `nat_bits_zero`: at width `0n` the answer is `Nil{}`, whatever `n` is.
- `nat_bits_succ`: at width `1n + w` the answer is the low bit
  `Nat.mod(n, 2n)` followed by `nat_bits(w, Nat.div(n, 2n))`.
- `nat_bits_len`: `nat_bits(w, n)` has `w` elements.
