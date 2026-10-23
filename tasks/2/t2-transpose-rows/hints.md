The reference `insert_row` matches on `r`, then on `cols`: an empty `r` gives
`cols`; `h <> t` with `Nil{}` columns gives `(h <> Nil{}) <> insert_row(t, Nil{})`;
with `c <> cs` gives `(h <> c) <> insert_row(t, cs)`. `transpose` matches on the
rows: `Nil{}` gives `Nil{}`, and `r <> rs` gives `insert_row(r, transpose(rs))`.

Every law but one closes by `{==}`: `transpose_nil`, `transpose_cons`,
`insert_row_nil`, `insert_row_empty_cols`, `insert_row_cons_cols` and
`transpose_two_by_two`.

`transpose_single_row` is an induction on `r`. `Nil{}` closes by `{==}`. In the
`h <> t` case `transpose([h <> t])` unfolds to `insert_row(h <> t, Nil{})`, which
steps to `(h <> Nil{}) <> insert_row(t, Nil{})`, and the hypothesis at `t`
covers the tail:

    %L.transpose_single_row(t) : {(h <> Nil{}) <> S.insert_row(t, Nil{}) == (h <> Nil{}) <> _ : List<&2, List<&2, Nat>>}
    {==}
