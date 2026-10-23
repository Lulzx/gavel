Implement `pow`, then prove the three laws in `LAWS.bend`.

`pow(a, b)` is `a` raised to the power `b`.

    pow(2n, 5n) == 32n
    pow(3n, 2n) == 9n
    pow(7n, 0n) == 1n

- `pow_zero`: `pow(x, 0n)` is `1n`.
- `pow_one`: `pow(x, 1n)` is `x`.
- `pow_succ`: `pow(x, 1n+p)` is `x` multiplied (by `Nat.mul`) by `pow(x, p)`.
