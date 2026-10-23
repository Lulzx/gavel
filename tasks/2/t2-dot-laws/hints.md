The reference matches on `xs`, then on `ys`: `Nil{}` on either answers `0n`, and
`h <> t` with `k <> u` answers `Nat.mul(h, k) + dot(t, u)`.

- `dot_nil_left` and `dot_cons` close by `{==}`: the outer match, and for
  `dot_cons` the inner one too, step on constructors.
- `dot_nil_right` is a match on `xs`. The `Nil{}` case and the `h <> t` case
  (where the inner match on the literal `Nil{}` picks `0n`) are both `{==}`.
  No induction is needed.
- `dot_shorter` is an induction on `xs`, and in the cons case a match on `ys`.
  `Nil{}` for `xs` and for `ys` are `{==}`. In the `k <> u` case the left side
  is `Nat.mul(h, k) + dot(t, u)` and the right side has `P.take` wrapped around
  `u`, so rewrite with `L.dot_shorter(t, u)`, written as
  `{Nat.mul(h, k) + S.dot(t, u) == Nat.mul(h, k) + _ : Nat}`, then `{==}`.
