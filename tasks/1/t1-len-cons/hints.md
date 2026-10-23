The reference matches on `xs`: `Nil{}` answers `0n`, and `h <> t` answers
`1n + len(t)`.

- `len_cons` and `len_single` close by `{==}`: `len` is applied to a literal
  cons, so it steps.
- `len_nil_right` is an induction on `xs`. The `Nil{}` case is `{==}`. In the
  cons case the left side reduces to `1n + S.len(P.append(t, Nil{}))`; rewrite
  with the hypothesis at `t` (hole in `1n + _`), then `{==}`.
