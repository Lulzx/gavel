Implement `sum_to`, then prove the three laws in `LAWS.bend`.

`sum_to(n)` is the sum `0n + 1n + ... + n`: `0n` at `0n`, and at `1n + p` the
sum up to `p` plus `1n + p`.

    sum_to(0n) == 0n
    sum_to(4n) == 10n

The laws use only Base's `+` and `*` on Nat; the prelude defines nothing.

- `sum_to_zero`: the sum up to `0n` is `0n`.
- `sum_to_succ`: the sum up to `1n + p` is the sum up to `p` plus `1n + p`.
- `sum_to_double`: twice the sum up to `n` is `n * (1n + n)`.
