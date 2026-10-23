The reference `row` matches on `ys`: `Nil{}` answers `Nil{}`, and `y <> t`
answers `P.MkPair{x, y} <> row(x, t)`. `cross` matches on `xs`: `Nil{}` answers
`Nil{}`, and `x <> t` answers `P.append(row(x, ys), cross(t, ys))`. `x` in `row`
and `ys` in `cross` are used repeatedly, so declare `+x` and `+ys`.

- `cross_nil`, `row_nil`, `row_cons`, `cross_cons`, `cross_two_two`: close by
  `{==}` (the last is a closed term).
- `cross_one`: the goal is `P.append(row(x, ys), Nil{})` against `row(x, ys)`,
  stuck behind the variable `ys`. A `Policy.` lemma `append_nil(ps)`:
  `P.append(ps, Nil{}) == ps`, an induction on `ps` (rewrite with the hypothesis
  at the tail, goal `{h <> P.append(t, Nil{}) == h <> _ : List<&2, P.Pair>}`,
  binding `+h`). Then:

      %Policy.append_nil(S.row(x, ys)) : {P.append(S.row(x, ys), Nil{}) == _ : List<&2, P.Pair>}
      {==}
