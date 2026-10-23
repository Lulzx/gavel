The reference matches on `xs`, then on `ys`: `Nil{}` answers `True{}`; `h <> t`
with `Nil{}` answers `False{}`; `+h <> t` with `+k <> u` answers
`Bool.or(P.lt(h, k), Bool.and(P.eq(h, k), lex_le(t, u)))`.

- `lex_le_nil_left`, `lex_le_nil_right` and `lex_le_cons` close by `{==}`.
- Two `Policy.` lemmas, each an induction on `a` (`0n` is `{==}`; `1n+p`
  rewrites with the flipped hypothesis then `{==}`):
  `eq_refl(a) : P.eq(a, a) == True{}` and `lt_irrefl(a) : P.lt(a, a) == False{}`.
- `lex_le_self` and `lex_le_append` are both inductions on `xs` with the same
  step (head bound `+h`). `Nil{}` is `{==}`. In the cons case the goal is
  `Bool.or(P.lt(h, h), Bool.and(P.eq(h, h), tail_test))`. Rewrite the tail test
  to `True{}` with the flipped hypothesis (`L.lex_le_self(t)` or
  `L.lex_le_append(t, ys)`), then `P.eq(h, h)` to `True{}` with the flipped
  `eq_refl(h)`, then `P.lt(h, h)` to `False{}` with the flipped `lt_irrefl(h)`;
  `Bool.or(False{}, True{})` reduces and `{==}` closes it.
