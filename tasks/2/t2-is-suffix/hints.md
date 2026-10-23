The reference walks `ys`, not `xs`. With `+xs` and a tail bound `+u`: `Nil{}`
answers `P.is_nil(xs)`, and `k <> u` answers
`Bool.or(P.eq_list(xs, k <> u), is_suffix(xs, u))`. Recursing on `xs` instead is
wrong.

- `is_suffix_nil_right` and `is_suffix_cons` close by `{==}`.
- `Policy.eq_refl(x) : P.eq(x, x) == True{}`: induction on `x`; `0n` is `{==}`,
  and `1n+p` rewrites with the flipped hypothesis then `{==}`.
- `Policy.eq_list_refl(xs) : P.eq_list(xs, xs) == True{}`: induction on `xs`;
  the cons case rewrites the tail with the flipped hypothesis and `P.eq(h, h)`
  with the flipped `eq_refl(h)`, then `{==}`.
- `Policy.or_true_right(a) : Bool.or(a, True{}) == True{}`: match on `a`, both
  cases `{==}`.
- `is_suffix_nil`: match on `ys`. `Nil{}` is `{==}`. For `k <> u` the first
  disjunct is `False{}` (`P.eq_list(Nil{}, k <> u)`) and the flipped hypothesis at
  `u` turns the rest into `True{}`; then `{==}`.
- `is_suffix_self`: induction on `xs`. `Nil{}` is `{==}`. For `h <> t`, rewrite
  `P.eq_list(h <> t, h <> t)` to `True{}` with the flipped
  `Policy.eq_list_refl(h <> t)`; `Bool.or(True{}, _)` then reduces.
- `is_suffix_append`: induction on `ys`. `Nil{}`: `P.append(Nil{}, xs)` is `xs`,
  so rewrite with the flipped `L.is_suffix_self(xs)`. For `k <> u`: rewrite the
  tail disjunct to `True{}` with the flipped hypothesis `L.is_suffix_append(xs, u)`,
  then the whole `Bool.or(_, True{})` to `True{}` with the flipped
  `Policy.or_true_right(P.eq_list(xs, k <> P.append(u, xs)))`; `{==}`.
