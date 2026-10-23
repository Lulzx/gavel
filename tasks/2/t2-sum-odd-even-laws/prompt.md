Implement `sum_odd` and `sum_even`, then prove the five laws in `LAWS.bend`.

`sum_odd(n)` is the sum of the first `n` odd numbers, `1n + 3n + ... + (2n - 1n)`.
`sum_even(n)` is the sum of the first `n` even numbers, `0n + 2n + ... +
(2n - 2n)`. Both are `0n` at `0n`.

    sum_odd(3n) == 9n
    sum_odd(0n) == 0n
    sum_even(3n) == 6n
    sum_even(1n) == 0n

- `sum_odd_zero`: the sum of no odd numbers is `0n`.
- `sum_odd_succ`: `sum_odd(1n + k)` is `sum_odd(k)` plus the next odd number,
  `k + k + 1n`.
- `sum_even_zero`: the sum of no even numbers is `0n`.
- `sum_even_succ`: `sum_even(1n + k)` is `sum_even(k)` plus the next even
  number, `k + k`.
- `sum_odd_sum_even`: `sum_odd(n)` is `sum_even(n) + n`.
