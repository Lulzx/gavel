The reference matches on the list: `Nil{}` gives `P.MkZ{Nil{}, Nil{}}`, and a cons
`+h <> +t` gives `P.MkZ{P.pfst(h) <> P.zfst(unzip(t)), P.psnd(h) <> P.zsnd(unzip(t))}`.
`h` and `t` are used twice, so they are bound reusable.

The first three laws close by `{==}`: `P.zfst` and `P.zsnd` step on the `P.MkZ`.

`unzip_len_fst` and `unzip_len_snd` are inductions on `ps`. `Nil{}` closes by
`{==}`. In the cons case both `P.llen` and `P.plen` step to `1n + ...`, and the
hypothesis at `t` covers the rest:

    %L.unzip_len_fst(t) : {1n + P.llen(P.zfst(S.unzip(t))) == 1n + _ : Nat}
    {==}

and the same with `zsnd` and `L.unzip_len_snd(t)` for the second.
