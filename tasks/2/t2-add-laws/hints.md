The reference matches on `a`: `0n` answers `b`, and `1n+p` answers
`1n + add(p, b)`.

Both laws are an induction on `x` with the same shape. The `0n` case closes by
`{==}`. In the `1n+p` case both sides step to `1n + ...`, so rewrite with the
hypothesis at `p` and close by `{==}`:

    %L.add_zero(p) : {1n+S.add(p, 0n) == 1n+_ : Nat}
    {==}

`add_succ` is the same with `L.add_succ(p, y)` and the goal
`{1n+S.add(p, 1n+y) == 1n+_ : Nat}`.
