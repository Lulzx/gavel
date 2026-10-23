The reference has `every_nth_go(xs, +m, i)` match on `xs`: `Nil{}` gives `Nil{}`;
`h <> +t` then matches on `i`: `0n` gives `h <> every_nth_go(t, m, m)` and `1n+q`
gives `every_nth_go(t, m, q)`. `m` and `t` are reusable (`+m`, `+t`) because
each is read more than once. `take_every_nth` matches on `n`: `0n` gives
`Nil{}`, and `1n+p` gives `every_nth_go(xs, p, 0n)`.

Every law but one closes by `{==}`. `take_every_nth_nil` matches on `n` first
(`0n` and `1n+p`), and both cases close by `{==}`.

`take_every_nth_one` is an induction on `xs` with `xs` and its tail reusable.
`Nil{}` closes by `{==}`. In the cons case `take_every_nth(1n, h <> t)` steps to
`h <> take_every_nth(1n, t)`, and the hypothesis at `t` says that tail is `t`.
Its direction is wrong for the rewrite, so flip it with `Equal.sym`:

    %Equal.sym(List<&2, Nat>, S.take_every_nth(1n, t), t, L.take_every_nth_one(t)) : {h <> _ == h <> t : List<&2, Nat>}
    {==}
