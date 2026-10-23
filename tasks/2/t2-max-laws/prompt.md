Implement `max`, then prove the four laws in `LAWS.bend`.

`max(a, b)` is the larger of the two numbers `a` and `b`.

    max(2n, 5n) == 5n
    max(5n, 2n) == 5n
    max(0n, 3n) == 3n

- `max_self`: the larger of `x` and `x` is `x`.
- `max_comm`: `max(x, y)` equals `max(y, x)`.
- `max_zero_left`: `max(0n, y)` is `y`.
- `max_succ_succ`: `max(1n+p, 1n+q)` is `1n + max(p, q)`.
