The reference matches on `xs`: `Nil{}` answers `ys`, and `h <> t` answers
`h <> append(t, ys)`.

- `append_nil_left`: the first argument is the literal `Nil{}`, so the match
  steps and `{==}` closes it.
- `append_nil`: an induction on `xs`. The `Nil{}` case is `{==}`. In the cons
  case the left side reduces to `h <> S.append(t, Nil{})`; rewrite with the
  hypothesis at `t`, then `{==}`.
- `append_assoc`: an induction on `xs`. The `Nil{}` case is `{==}`. In the cons
  case both sides reduce to `h` consed onto the two tails; rewrite with
  `L.append_assoc(t, ys, zs)` and close with `{==}`.
