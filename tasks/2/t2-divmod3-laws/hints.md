The reference matches on `n` with four cases: `0n`, `1n` and `2n` answer
`P.MkPair{0n, 0n}`, `P.MkPair{0n, 1n}` and `P.MkPair{0n, 2n}`, and `3n++k`
answers `P.shift(divmod3(k))`.

- `divmod3_zero`, `divmod3_one`, `divmod3_two` and `divmod3_succ3` close by
  `{==}`: the argument is a literal or `3n + k`, so the match steps.
- `divmod3_rem` is an induction on `n` with the same four cases. The three
  literal cases are `{==}`. In the `3n++k` case the goal is about
  `P.snd(P.shift(divmod3(k)))`, so it needs a lemma
  `Policy.snd_shift(p) : P.snd(P.shift(p)) == P.snd(p)`, proved by matching on
  `p` as `P.MkPair{q, r}` and `{==}`. Flip it with
  `Equal.sym(Nat, P.snd(P.shift(S.divmod3(k))), P.snd(S.divmod3(k)), Policy.snd_shift(S.divmod3(k)))`
  and rewrite the hole in `Nat.is_lt(_, 3n) == True{}`. Then rewrite with the
  hypothesis `L.divmod3_rem(k)` and close with `{==}`.
