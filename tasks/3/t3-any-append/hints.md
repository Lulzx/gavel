The reference matches on the list: `Nil{}` answers `False{}` and `h <> t`
answers `Bool.or(h, any(t))`.

- `any_nil` and `any_cons`: both sides compute, so each closes by `{==}`.
- `any_append`: induction on `xs` (both binders are `+`). `Nil{}` closes by
  `{==}`. In the cons case rebind `+ys = ys`; the left side unfolds to
  `Bool.or(h, S.any(P.append(t, ys)))`. Rewrite the inner search with the
  hypothesis `L.any_append(t, ys)` (flipped with `Equal.sym`), leaving

      Bool.or(h, Bool.or(S.any(t), S.any(ys))) == Bool.or(Bool.or(h, S.any(t)), S.any(ys))

  which is associativity of `Bool.or`. That is a `Policy.` lemma
  `Bool.or(a, Bool.or(b, c)) == Bool.or(Bool.or(a, b), c)`, with `b` and `c`
  erased, proved by matching on `a`: both the `False{}` and the `True{}` case
  close by `{==}`. Rewrite with it on the right side and close by `{==}`.
