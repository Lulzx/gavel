The reference matches on the list, then on its tail: `Nil{}` and a one-element
list give `Nil{}`; for `h <> (k <> u)` it gives `h + k <> sum_adjacent(k <> u)`.
`h`, `k` and the tail are read twice, so they are bound reusable (`+h <> t`,
`+k <> u`).

Five laws close by `{==}`: `sum_adjacent_nil`, `sum_adjacent_single`,
`sum_adjacent_cons`, `sum_adjacent_pair` and `sum_adjacent_three`. The walk is
stuck only on the shape of the list, and each of these fixes that shape.

`sum_adjacent_len` is an induction on `xs`, with the front element `x` left
alone (the hypothesis is used at `(u, k)`). Match `xs` as `Nil{}` or
`+k <> +u`. `Nil{}` closes by `{==}`. In the cons case both sides reduce to
`1n +` something before the hypothesis is needed:

    %L.sum_adjacent_len(u, k) : {1n + P.len(S.sum_adjacent(k <> u)) == 1n + _ : Nat}
    {==}
