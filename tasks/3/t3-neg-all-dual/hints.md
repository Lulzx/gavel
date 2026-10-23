The reference maps `Nil{}` to `Nil{}` and `h <> t` to
`Bool.not(h) <> neg_all(t)`.

- `neg_all_nil` and `neg_all_cons`: `{==}`.

The last three are inductions on `xs` (the `+xs` binder makes the tail
reusable), and each needs a `Policy.` fact about `Bool`, proved by matching on
the first argument (both cases `{==}`):

- `b == Bool.not(Bool.not(b))`
- `Bool.not(Bool.or(a, b)) == Bool.and(Bool.not(a), Bool.not(b))`
- `Bool.not(Bool.and(a, b)) == Bool.or(Bool.not(a), Bool.not(b))`

These are stated with the term to be produced on the left, so they are used
bare; only the hypotheses are flipped with `Equal.sym`.

- `neg_all_involutive`: `Nil{}` is `{==}`. In the cons case the goal is
  `Bool.not(Bool.not(h)) <> S.neg_all(S.neg_all(t)) == h <> t`. Rewrite the
  head with the double-negation fact
  (`{_ <> S.neg_all(S.neg_all(t)) == h <> t : List<&2, Bool>}`), then the tail
  with the flipped hypothesis (`{h <> _ == h <> t : ...}`), then `{==}`.
- `neg_all_all`: cons case, the left reduces to
  `Bool.and(Bool.not(h), P.all_bool(S.neg_all(t)))`. Rewrite the second
  argument with the flipped hypothesis to `Bool.not(P.any_bool(t))`, then
  rewrite the whole left side with the `not_or` fact at `(h, P.any_bool(t))`
  (`{_ == Bool.not(Bool.or(h, P.any_bool(t))) : Bool}`), then `{==}`.
- `neg_all_any`: the same with the folds exchanged and the `not_and` fact at
  `(h, P.all_bool(t))`. The two de Morgan directions are separate lemmas.
