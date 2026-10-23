Implement `nat_sqrt`, then prove the six laws in `LAWS.bend`.

`nat_sqrt(n)` is the largest `k` whose square is at most `n`: the integer square
root, rounded down. `0n` gives `0n`.

    nat_sqrt(10n) == 3n
    nat_sqrt(16n) == 4n
    nat_sqrt(15n) == 3n
    nat_sqrt(0n) == 0n

The laws use `P.le_ind(a, b)`, which is `1n` when `a` is at most `b` and `0n`
otherwise.

- `nat_sqrt_zero`: `nat_sqrt(0n)` is `0n`.
- `nat_sqrt_succ`: `nat_sqrt(1n + n)` is `nat_sqrt(n)` plus `P.le_ind(m * m, 1n + n)`,
  where `m` is `1n + nat_sqrt(n)` and `*` is `Nat.mul`: the root goes up by one
  exactly when the next square still fits under `1n + n`.
- `nat_sqrt_mono`: `P.le_ind(nat_sqrt(n), nat_sqrt(1n + n))` is `1n`, that is,
  the root of `n` is at most the root of `1n + n`.
- `nat_sqrt_four`: `nat_sqrt(4n)` is `2n`.
- `nat_sqrt_eight`: `nat_sqrt(8n)` is `2n`.
- `nat_sqrt_nine`: `nat_sqrt(9n)` is `3n`.
