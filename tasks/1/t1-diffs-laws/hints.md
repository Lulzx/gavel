The reference matches on `xs`, and on a cons matches again on the tail:
`Nil{}` answers `Nil{}`, a one-element list answers `Nil{}`, and
`h <> (h2 <> t2)` answers `P.sub(h2, h) <> diffs(h2 <> t2)`. `h2` is used
twice, so it is bound as `+h2`.

- `diffs_nil`, `diffs_single` and `diffs_cons` each close by `{==}`: the
  arguments are literal constructors, so both matches step.
- `diffs_len` is an induction on `xs`, with `x` carried along (the law binds
  `xs` first so the recursion can shrink it while `x` changes). The `Nil{}`
  case is `{==}`. In the `h <> t` case the left side reduces to
  `1n + P.len(S.diffs(h <> t))` and the right to `1n + P.len(t)`; rewrite with
  the hypothesis at the tail, `L.diffs_len(t, h)`, then `{==}`.
