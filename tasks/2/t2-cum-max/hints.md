The reference `max_all` matches on `ys`: `Nil{}` answers `Nil{}`, and `h <> t`
answers `Nat.max(h, m) <> max_all(t, m)`; declare `+m`. `cum_max` matches on the
list: `Nil{}` answers `Nil{}`, and `+h <> t` answers
`h <> max_all(cum_max(t), h)`. The suffix is computed first, then the head is
folded in. `h` is used twice, so bind `+h`.

- `max_all_nil`, `max_all_cons`, `cum_max_nil`, `cum_max_single`, `cum_max_cons`,
  `cum_max_three`: close by `{==}`.
- `cum_max_len`: induction on `xs`, bound `+h <> +t`. It needs a `Policy.` lemma
  `max_all_len(ys, m)`: `P.len(max_all(ys, m)) == P.len(ys)`, an induction on
  `ys` (the step rewrites with the hypothesis, goal
  `{1n + P.len(S.max_all(t, m)) == 1n + _ : Nat}`). The `Nil{}` case is `{==}`.
  The cons case does two rewrites, with the law's own hypothesis at `t` and then
  with `max_all_len(cum_max(t), h)`, both with goal
  `{1n + P.len(S.max_all(S.cum_max(t), h)) == 1n + _ : Nat}`, then `{==}`.
