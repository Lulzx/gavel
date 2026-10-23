The reference matches on the count, then on the list: `0n` answers `y <> xs`;
`1n+p` answers `y <> Nil{}` on `Nil{}` and `h <> insert_at(p, t, y)` on `h <> t`.

- `insert_at_zero`, `insert_at_nil` and `insert_at_cons` close by `{==}`: the
  count and (for the last two) the list are constructors, so the matches step.
- `insert_at_take_drop` is an induction on `n`, with a split on `xs` in the
  successor case, because `P.take` and `P.drop` match on the count and then on
  the list. `0n` is `{==}` for any `xs`. For `1n+m`, `Nil{}` is `{==}`. For
  `h <> t` the left side is `h <> insert_at(m, t, y)`, so rewrite with the
  hypothesis at `m` and `t`, flipped because the goal has the left-hand side
  where the hole is:

      %Equal.sym(List<Nat>, S.insert_at(m, t, y), P.append(P.take(m, t), y <> P.drop(m, t)), L.insert_at_take_drop(m, t, y)) : {h <> _ == h <> P.append(P.take(m, t), y <> P.drop(m, t)) : List<Nat>}
      {==}
