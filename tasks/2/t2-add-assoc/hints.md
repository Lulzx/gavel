The reference matches on `a`: `0n` answers `b`, and `1n+p` answers
`1n + add(p, b)`.

Both laws are an induction on `x` with the same shape. The `0n` case closes by
`{==}`. In the `1n+p` case both sides step to `1n + ...`, so rewrite with the
hypothesis at `p` (the hole sits under the `1n+`) and close by `{==}`:

    %L.add_one(p) : {1n+S.add(p, 1n) == 1n+_ : Nat}
    {==}

`add_assoc` is the same with the hypothesis `L.add_assoc(p, y, z)`.
