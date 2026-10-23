The reference matches on `a`: `0n` answers `b`, and `1n+p` answers
`1n + add(p, b)`.

`add_plus` is an induction on `x`, with `y` left general. In the `0n` case both
sides reduce to `y`, so `{==}` closes it. In the `1n+p` case the left side
reduces to `1n + S.add(p, y)` and the right side to `1n + (p + y)`; rewrite with
the hypothesis at `p`, `L.add_plus(p, y)`, and close with `{==}`.
