The reference `log2_go` matches on the width `w` first: `0n` answers `0n`; for
`1n+p` it matches on `n`: `0n` and `1n+0n` answer `0n`, and `1n+1n+q` answers
`1n + log2_go(p, P.half(1n + 1n + q))`. `n` is declared `+n`. `nat_log2(n)` is
simply `log2_go(n, n)`: the number itself is always enough width.

Nine laws close by `{==}` with no case split: `log2_go_no_fuel`, `log2_go_one`,
`log2_go_step`, `nat_log2_handoff`, and the five closed values
`nat_log2_zero`, `_one`, `_two`, `_seven`, `_eight`.

`log2_go_zero` is the only one that needs a split: match on `w`. Both `0n` and
`1n+wp` close by `{==}` (the inner match reads the literal `0n`), so no
hypothesis is used.
