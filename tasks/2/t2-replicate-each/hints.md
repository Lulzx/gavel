The reference matches on the list: `Nil{}` answers `Nil{}`, and `h <> t`
answers `P.append(P.rep(h, n), replicate_each(t, n))`. `n` is used twice, so it
is declared `+n`.

- `replicate_each_nil`, `replicate_each_cons` and `replicate_each_two` close by
  `{==}`.
- `replicate_each_zero`: induction on `xs`, since the count is the literal `0n`
  but the list is a variable. `Nil{}` is `{==}`. In the cons case `P.rep(h, 0n)`
  is `Nil{}`, so the `P.append` drops out and the goal is the tail's answer;
  rewrite with the hypothesis at `t`, then `{==}`:
  `%L.replicate_each_zero(t) : {S.replicate_each(t, 0n) == _ : List<&2, Nat>}`.
- `replicate_each_one`: induction on `xs`. `Nil{}` is `{==}`. In `+h <> +t`,
  `P.rep(h, 1n)` is `h <> Nil{}`, so the goal is `h` consed onto the tail's
  answer; rewrite with the hypothesis at `t`, then `{==}`:
  `%L.replicate_each_one(t) : {h <> S.replicate_each(t, 1n) == h <> _ : List<&2, Nat>}`.
