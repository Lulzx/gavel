Implement `add` and `mul`, then prove the four laws in `LAWS.bend`.

`add(a, b)` is the sum of `a` and `b`. `mul(a, b)` is the product of `a` and
`b`.

    add(2n, 3n) == 5n
    mul(3n, 4n) == 12n
    mul(5n, 0n) == 0n
    mul(0n, 5n) == 0n

- `add_plus`: `add(x, y)` equals Base's built-in `x + y`.
- `mul_zero`: `mul(x, 0n)` is `0n`.
- `mul_succ_left`: `mul(1n+x, y)` equals Base's `y + mul(x, y)`.
- `mul_zero_left`: `mul(0n, y)` is `0n`.
