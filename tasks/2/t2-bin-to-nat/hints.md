The reference matches on the list: `Nil{}` answers `0n`, and `h <> t` answers
`h + 2n * bin_to_nat(t)`.

- `bin_to_nat_nil` and `bin_to_nat_cons`: close by `{==}`.
- `bin_to_nat_nat_bits`: induction on the width `w`, not on `n`; the `0n` case
  is `{==}`. In the `1n+p` case `P.nat_bits` unfolds to a cons, leaving
  `Nat.mod(n, 2n) + 2n * bin_to_nat(nat_bits(p, Nat.div(n, 2n)))` against the
  same with `P.low(p, Nat.div(n, 2n))`. The hypothesis is used at width `p` and
  number `Nat.div(n, 2n)`; it states `bin_to_nat(...) == low(...)`, and the term
  to replace is the `bin_to_nat` one, so flip it with `Equal.sym`:

      %Equal.sym(Nat, S.bin_to_nat(P.nat_bits(p, Nat.div(n, 2n))), P.low(p, Nat.div(n, 2n)), L.bin_to_nat_nat_bits(p, Nat.div(n, 2n))) :
          {Nat.mod(n, 2n) + 2n * _ == Nat.mod(n, 2n) + 2n * P.low(p, Nat.div(n, 2n)) : Nat}
      {==}

  `Nat.mod` and `Nat.div` stay symbolic; no arithmetic lemma is needed.
