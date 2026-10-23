The reference matches on the count `n` and then on the list: `0n` answers
`P.MkDuo{Nil{}, xs}`; at `1n+p`, `Nil{}` answers `P.MkDuo{Nil{}, Nil{}}` and
`h <> +t` answers
`P.MkDuo{h <> P.left_half(split_at(p, t)), P.right_half(split_at(p, t))}`. The
tail `t` is used twice, once per half, so it is bound `+t`.

- `split_at_zero`, `split_at_cons_left` and `split_at_cons_right` close by
  `{==}` (the last two project a field of the pair the body builds).
- `split_at_nil`: the list is a literal but the count is a variable, so match on
  `n`; both cases are `{==}`.
- `split_at_decomp`: induction on `n`, with a match on `xs` in the `1n+p` case.
  `0n` and `Nil{}` are `{==}`. In `h <> t` rewrite with the hypothesis at
  `(p, t)`, then `{==}`:

      %L.split_at_decomp(p, t) : {h <> P.append(P.left_half(S.split_at(p, t)), P.right_half(S.split_at(p, t))) == h <> _ : List<&2, Nat>}
