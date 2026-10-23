The reference matches on the list: `Nil{}` gives `Nil{}`, and `h <> t` gives
`P.MkPair{h, k} <> zip_with_const(t, k)`. `k` is used twice, so it is `+k`.

`zip_with_const_nil` and `zip_with_const_step` close by `{==}`.

`zip_with_const_fsts` and `zip_with_const_snds` are inductions on `xs`, matching
`Nil{}` (closes by `{==}`) and `+h <> t` (with `h` reusable, since it is read
twice). In the cons case both sides step to `h <> ...` (resp. `k <> ...`)
around the hypothesis at `t`. Each hypothesis has the observed side on the left,
which is the side the goal has it on, so flip it with `Equal.sym`:

    %Equal.sym(List<Nat>, P.fsts(S.zip_with_const(t, k)), t, L.zip_with_const_fsts(t, k)) : {h <> _ == h <> t : List<Nat>}
    {==}

    %Equal.sym(List<Nat>, P.snds(S.zip_with_const(t, k)), P.repeat(P.len(t), k), L.zip_with_const_snds(t, k)) : {k <> _ == k <> P.repeat(P.len(t), k) : List<Nat>}
    {==}
