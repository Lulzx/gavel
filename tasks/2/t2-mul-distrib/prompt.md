Implement `mul`, then prove the two laws in `LAWS.bend`.

`mul(a, b)` is the product of the two numbers `a` and `b`.

    mul(3n, 4n) == 12n
    mul(0n, 7n) == 0n
    mul(1n, 5n) == 5n

- `mul_one_left`: `mul(1n, x)` is `x`.
- `mul_distrib`: `mul(x + y, z)` is `mul(x, z) + mul(y, z)`.
