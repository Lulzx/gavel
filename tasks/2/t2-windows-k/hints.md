The reference has two functions, both with `k` and `xs` reusable (`+k`, `+xs`).
`windows_go(ys, k, xs)` matches on `ys`: `Nil{}` gives `Nil{}`, and `h <> t`
gives `P.take(xs, k) <> windows_go(t, k, P.tail(xs))`. `windows(k, xs)` matches
on `k`: `0n` gives `Nil{}`, and `1n+p` gives
`windows_go(P.lookahead(xs, k), k, xs)`.

Four laws close by `{==}`: `windows_zero`, `windows_succ`, `windows_go_nil`,
`windows_go_step`. Each names the constructor the matches need.

`windows_nil` has a variable `k` and a stuck `P.lookahead`, so match on `k`:
the `0n` case closes by `{==}`, and in the `1n+p` case `P.lookahead(Nil{}, ...)`
reduces to `Nil{}` (it matches on the length first, then `P.skip` on the empty
list), so that case closes by `{==}` too.
