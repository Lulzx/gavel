The reference matches on the count: `0n` answers `Nil{}`, and `1n+p` answers
`a <> alternate(p, b, a)`. The count must be the first parameter, since the
swap changes the other two on each call. `a` and `b` are each used twice
(in the recursive call and the swap), so declare them `+a` and `+b`.

- `alternate_zero`, `alternate_cons`, `alternate_two`: each closes by `{==}`.
  The match steps on `0n`, on `1n+n`, and (twice) on the literal `2n`.
- `alternate_len`: induction on `n`. The `0n` case closes by `{==}`. In the
  `1n+p` case the goal reduces to `1n + P.len(alternate(p, b, a)) == 1n + p`.
  The hypothesis is used at the swapped arguments, `L.alternate_len(p, b, a)`,
  and it has to be flipped with `Equal.sym` because the term to replace is the
  length, which sits on the left of the hypothesis:

      %Equal.sym(Nat, P.len(S.alternate(p, b, a)), p, L.alternate_len(p, b, a)) : {1n + _ == 1n + p : Nat}
      {==}
