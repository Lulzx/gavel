Implement `add` and `mul`, then prove the three laws in `LAWS.bend`.

`add(a, b)` is the sum of `a` and `b`, and `mul(a, b)` is their product.

    add(3n, 4n) == 7n
    mul(3n, 4n) == 12n
    mul(0n, 7n) == 0n

- `add_plus`: `add(x, y)` is `x + y`.
- `mul_one_left`: `mul(1n, x)` is `x`.
- `mul_succ`: `mul(x, 1n+y)` is `add(mul(x, y), x)`.
