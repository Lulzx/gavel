The reference matches on the width `w`: `0n` answers `Nil{}`, and `1n+p`
answers `Nat.mod(n, 2n) <> nat_bits(p, Nat.div(n, 2n))`. The width comes first
because it is what shrinks while `n` is halved, and `n` is declared `+n`.

- `nat_bits_zero` and `nat_bits_succ` close by `{==}`.
- `nat_bits_len`: induction on `w`, with `n` left general because the
  hypothesis is used at the halved number `Nat.div(n, 2n)`. `0n` is `{==}`. In
  `1n+p` the goal is `1n + P.len(nat_bits(p, Nat.div(n, 2n))) == 1n + p`; the
  hypothesis says `P.len(...) == p`, so flip it with `Equal.sym` before
  rewriting:

      %Equal.sym(Nat, P.len(S.nat_bits(p, Nat.div(n, 2n))), p, L.nat_bits_len(p, Nat.div(n, 2n))) : {1n + _ == 1n + p : Nat}
      {==}
