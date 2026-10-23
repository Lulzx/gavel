Implement `add` and `mul`, then prove the four laws in `LAWS.bend`.

`add(a, b)` is the sum of `a` and `b`. `mul(a, b)` is the product of `a` and
`b`.

    add(2n, 3n) == 5n
    mul(3n, 4n) == 12n
    mul(2n, 5n) == 10n
    mul(0n, 5n) == 0n

- `mul_zero`: `mul(0n, x)` is `0n`.
- `mul_two`: `mul(2n, x)` equals Base's `x + x`.
- `mul_succ`: `mul(1n+a, b)` is `add(b, mul(a, b))`.
- `add_zero`: `add(x, 0n)` is `x`.
