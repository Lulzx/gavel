Implement `pred` and `add`, then prove the five laws in `LAWS.bend`.

`pred(n)` is the predecessor of `n`: one less, and `0n` for `0n`. `add(a, b)` is
the sum of `a` and `b`.

    pred(5n) == 4n
    pred(0n) == 0n
    add(3n, 4n) == 7n

- `pred_succ`: `pred(1n+x)` is `x`.
- `add_one`: `add(x, 1n)` is `1n+x`.
- `pred_zero`: `pred(0n)` is `0n`.
- `add_zero`: `add(x, 0n)` is `x`.
- `add_succ`: `add(a, 1n+b)` is `1n + add(a, b)`.
