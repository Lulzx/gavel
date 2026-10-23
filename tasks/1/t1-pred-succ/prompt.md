Implement `add` and `pred`, then prove the five laws in `LAWS.bend`.

`add(a, b)` is the sum of `a` and `b`. `pred(a)` is the predecessor of `a`, and
`pred(0n)` is `0n`.

    add(2n, 3n) == 5n
    pred(5n)    == 4n
    pred(0n)    == 0n

- `pred_succ`: `pred(1n+x)` is `x`.
- `pred_add_one`: `pred(add(x, 1n))` is `x`.
- `pred_zero`: `pred(0n)` is `0n`. The law takes an `x` that it does not use.
- `add_zero`: `add(x, 0n)` is `x`.
- `add_succ`: `add(a, 1n+b)` is `1n + add(a, b)`.
