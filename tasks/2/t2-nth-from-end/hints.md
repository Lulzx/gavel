The reference matches on the list: `Nil{}` answers `d`, and `+h <> +t` answers
`P.pick_if(P.eq(P.len(t), k), h, nth_from_end(t, k, d))`. The test is a computed
value, so it goes through `P.pick_if` rather than a `match`. `k` and `d` are `+`.

Six laws close by `{==}`, since the lists are literal and everything unfolds:
`nth_from_end_nil`, `_step`, `_pair_last`, `_pair_first`, `_third` and `_out`.

`nth_from_end_last` is an induction on `n`, with `x`, `y`, `d` left general.
`0n` is `{==}`. It needs a `Policy.` lemma
`len_snoc(a, x)`: `{P.len(P.snoc(a, x)) == 1n + P.len(a) : Nat}`, by induction on
`a` (the cons case rewrites with the hypothesis flipped by `Equal.sym`). In `1n+p`
the walk's test is `P.eq(P.len(P.snoc(...)), 0n)`: rewrite `P.len(P.snoc(...))`
to `1n + P.len(P.same(p, x))` with the flipped lemma, so the test becomes
successor against `0n`, which reduces to `False{}`; then rewrite with the
hypothesis at `p` and close with `{==}`. The step reuses `p`, `x`, `y`, `d` more
than once, so rebind each first (`+rp = p` and so on).
