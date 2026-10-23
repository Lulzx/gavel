Implement `min`, then prove the four laws in `LAWS.bend`.

`min(a, b)` is the smaller of the two numbers `a` and `b`.

    min(2n, 5n) == 2n
    min(5n, 2n) == 2n
    min(0n, 3n) == 0n

- `min_self`: the smaller of `x` and `x` is `x`.
- `min_comm`: `min(x, y)` equals `min(y, x)`.
- `min_zero_left`: `min(0n, y)` is `0n`.
- `min_succ_succ`: `min(1n+p, 1n+q)` is `1n + min(p, q)`.
