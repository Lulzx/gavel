The reference matches on `xs`, then on `ys`: `Nil{}` answers `True{}`; `h <> t`
with `Nil{}` answers `False{}`; `h <> t` with `k <> u` answers
`Bool.and(P.eq(h, k), is_prefix(t, u))`.

- `is_prefix_nil`, `is_prefix_nil_right` and `is_prefix_cons` close by `{==}`.
- `Policy.eq_refl(x) : P.eq(x, x) == True{}` is an induction on `x`: `0n` is
  `{==}`; in `1n+p`, `P.eq` steps one successor off each side, so rewrite with
  the flipped hypothesis
  `Equal.sym(Bool, P.eq(p, p), True{}, Policy.eq_refl(p))` and close with `{==}`.
- `is_prefix_self` and `is_prefix_append` are both inductions on `xs` and have
  the same step. `Nil{}` is `{==}`. In the cons case the goal reduces to
  `Bool.and(P.eq(h, h), is_prefix(t, t))` (for `append`,
  `is_prefix(t, P.append(t, ys))`). Rewrite the tail test to `True{}` with the
  flipped hypothesis, then `P.eq(h, h)` to `True{}` with the flipped
  `Policy.eq_refl(h)`, each time writing the goal around a `_` hole; then
  `Bool.and(True{}, True{})` reduces and `{==}` closes it.
