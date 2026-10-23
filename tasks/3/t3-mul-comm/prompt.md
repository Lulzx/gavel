Implement `mul`, then prove the four laws in `LAWS.bend`.

`mul(a, b)` is the product of `a` and `b` on `Nat`.

    mul(3n, 4n) == 12n
    mul(0n, 7n) == 0n
    mul(5n, 1n) == 5n

The prelude is empty; the laws use only Base's `+`, which steps on its left
argument.

- `mul_one_right`: multiplying by `1n` on the right gives the left factor.
- `mul_zero_right`: multiplying by `0n` on the right gives `0n`.
- `mul_succ_right`: multiplying `x` by `1n + y` is `x` plus `x` times `y`.
- `mul_comm`: the order of the factors does not matter.
