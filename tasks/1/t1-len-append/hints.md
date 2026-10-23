Both targets match on their first argument. `len` answers `0n` for `Nil{}` and
`1n + len(t)` for `h <> t`; `append` answers `ys` for `Nil{}` and
`h <> append(t, ys)` for `h <> t`.

- `len_cons`, `len_single`, `append_nil_left` and `append_cons` all close by
  `{==}`: each applies a target to a literal constructor, so it steps.
- `len_nil_right` is an induction on `xs`. The `Nil{}` case is `{==}`. In the
  cons case the left side reduces to `1n + S.len(S.append(t, Nil{}))`; rewrite
  with the hypothesis at `t` (hole in `1n + _`), then `{==}`.
