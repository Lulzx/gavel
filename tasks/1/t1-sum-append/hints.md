Both targets match on `xs`. `sum` answers `0n` for `Nil{}` and `h + sum(t)` for
`h <> t`; `append` answers `ys` for `Nil{}` and `h <> append(t, ys)` for
`h <> t`.

- `sum_cons`, `append_cons` and `append_nil_left` close by `{==}`: each applies
  a target to a literal constructor, so it steps.
- `sum_append` is an induction on `xs`, and needs one `Policy.` lemma,
  `Policy.add_assoc(a, b, c) : a + (b + c) == (a + b) + c`, an induction on `a`
  (rewrite with the hypothesis at `p`, hole in `1n + _`). Mark `b` and `c` as
  erased (`-b`, `-c`). The `Nil{}` case is `{==}`. In the `h <> t` case the
  goal is `h + S.sum(S.append(t, ys)) == (h + S.sum(t)) + S.sum(ys)`. The
  hypothesis `L.sum_append(t, ys)` has `S.sum(S.append(t, ys))` on its left,
  which is where the goal has it, so flip it with `Equal.sym` and rewrite. Then
  `Policy.add_assoc(h, S.sum(t), S.sum(ys))` lines the parentheses up, and
  `{==}` closes it.
