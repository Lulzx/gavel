The reference is a fold: `Nil{}` answers `0n`, and `h <> t` answers
`h + sum(t)`.

- `sum_cons` closes by `{==}`.
- `sum_replicate_mul` is an induction on `n`. The `0n` case is `{==}`. In the
  `1n+k` case `P.replicate(1n + k, x)` unfolds to `x <> P.replicate(k, x)`, so
  the left side is `x + S.sum(P.replicate(k, x))`, and `P.mul(1n + k, x)`
  already computes to `x + P.mul(k, x)`. Rewrite with the hypothesis
  `L.sum_replicate_mul(k, x)`, flipped with `Equal.sym`, under `x + _`, then
  `{==}`. No arithmetic lemma is needed.
- `sum_replicate_one` is the same induction at element `1n`, proved on its own
  rather than by citing the law above: the step is `1n + S.sum(P.replicate(k,
  1n)) == 1n + k`, closed by the hypothesis `L.sum_replicate_one(k)` (flipped)
  under `1n + _`, then `{==}`.

Each step uses the pattern variable `k` only once, so no rebinding is needed.
