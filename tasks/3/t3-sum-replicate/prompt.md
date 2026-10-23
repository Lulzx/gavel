Implement `sum`, then prove the three laws in `LAWS.bend`.

`sum(xs)` is the sum of the elements of `xs`, and `0n` for the empty list.

    sum([1n, 2n, 3n]) == 6n
    sum(Nil{}) == 0n

`P.replicate(n, x)` is the list of `n` copies of `x`, and `P.mul(a, b)` is the
product of `a` and `b`.

- `sum_replicate_mul`: the sum of `n` copies of `x` is `n` times `x`.
- `sum_replicate_one`: the sum of `n` copies of `1n` is `n`.
- `sum_cons`: the sum of `h <> t` is `h` plus the sum of `t`.
