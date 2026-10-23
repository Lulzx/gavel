Implement `sub`, then prove the two laws in `LAWS.bend`.

`sub(a, b)` is truncated subtraction: `a - b` when `a` is at least `b`, and
`0n` otherwise.

    sub(5n, 2n) == 3n
    sub(2n, 5n) == 0n
    sub(4n, 4n) == 0n

The laws use the prelude's `P.pred(n)`, the predecessor of `n`, with
`P.pred(0n)` equal to `0n`.

- `sub_zero`: subtracting `0n` from `x` leaves `x`.
- `sub_succ`: subtracting `1n + y` from `x` is the predecessor of subtracting
  `y` from `x`.
