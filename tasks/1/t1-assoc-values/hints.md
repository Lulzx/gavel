Both targets match on `kvs` with `P.Mk{hk, hv} <> t` in the cons case:
`values` answers `Nil{}` and `hv <> values(t)`, and `sum_values` answers `0n`
and `hv + sum_values(t)`. Neither uses `hk`.

- `values_nil`, `values_cons`, `values_put`, `sum_values_nil` and
  `sum_values_cons` all close by `{==}`. `P.assoc_put` reduces to a literal
  cons, so `values_put` is the same step as `values_cons`. `values_nil` and
  `sum_values_nil` take no parameters.
- `sum_values_values` is an induction on `kvs`. The `Nil{}` case is `{==}`
  (both sides are `0n`). In the cons case the sides reduce to
  `hv + S.sum_values(t)` and `hv + P.nsum(S.values(t))`; rewrite with
  `L.sum_values_values(t)` and close with `{==}`.
