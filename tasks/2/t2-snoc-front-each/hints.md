Each function matches on the list of rows. `snoc_each`: `Nil{}` answers `Nil{}`
and `l <> t` answers `P.snoc(l, y) <> snoc_each(t, y)`. `front_each`: `Nil{}`
answers `Nil{}` and `l <> t` answers `(y <> l) <> front_each(t, y)`. `y` is
declared `+y` in both.

- The four laws `snoc_each_nil`, `snoc_each_cons`, `front_each_nil` and
  `front_each_cons` close by `{==}`.
- `snoc_front_commute`: induction on `xss`. `Nil{}` is `{==}`. In `l <> t` both
  sides unfold to the same first row, `y <> P.snoc(l, z)`, in front of the
  tails' results. Rewrite with the hypothesis at `t`, with the unfolded first
  row written out in the motive, then `{==}`:

      %L.snoc_front_commute(t, y, z) : {(y <> P.snoc(l, z)) <> S.snoc_each(S.front_each(t, y), z) == (y <> P.snoc(l, z)) <> _ : List<&2, List<&2, Nat>>}
