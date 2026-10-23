Implement `choose`, then prove the four laws in `LAWS.bend`.

`choose(n, k)` is the number of ways to pick `k` items out of `n` (the binomial
coefficient). Choosing `0n` items is `1n` way, including out of nothing. Choosing
a positive number of items out of nothing is `0n` ways.

    choose(5n, 2n) == 10n
    choose(4n, 0n) == 1n
    choose(0n, 0n) == 1n
    choose(2n, 3n) == 0n

- `choose_zero_left`: `choose(0n, 1n + k) == 0n`.
- `choose_zero_right`: `choose(n, 0n) == 1n` for every `n`.
- `choose_step`: Pascal's rule: `choose(1n + n, 1n + k)` is
  `Nat.add(choose(n, 1n + k), choose(n, Nat.sub(1n + k, 1n)))`: the selections
  that leave the first item out plus the ones that take it.
- `choose_five_two`: `choose(5n, 2n) == 10n`.
