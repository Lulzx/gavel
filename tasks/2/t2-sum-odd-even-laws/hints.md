The reference defines each by matching on `n`: `0n` gives `0n`, and `1n+k` gives
`sum_odd(k) + (k + k + 1n)` (resp. `sum_even(k) + (k + k)`). `k` is used
several times, so it is bound reusable (`1n++k`).

The first four laws close by `{==}`: both sides step on the successor, or are
the `0n` case.

`sum_odd_sum_even` is an induction on `n` (`0n` closes by `{==}`), and the step
needs two `Policy.` lemmas, both inductions on `a`:

- `add_assoc`: `{a + (b + c) == (a + b) + c : Nat}`, with `b`, `c` erased.
- `succ_right`: `{a + 1n == 1n + a : Nat}`. Its step flips the hypothesis with
  `Equal.sym`, since the hypothesis eliminates the left side of the goal.

In the step the goal is `sum_odd(k) + ((k + k) + 1n)` against
`(sum_even(k) + (k + k)) + (1n + k)`. Flip the hypothesis at `k` with
`Equal.sym` to replace `sum_odd(k)` by `sum_even(k) + k`; use `succ_right(k)`
to turn the `1n + k` into `k + 1n`; then both sides are the same terms
(`sum_even(k)`, `k`, `k`, `k`, `1n`) grouped differently, and a run of
`add_assoc` rewrites (at `(sum_even(k), k, k + k + 1n)`,
`(sum_even(k), k + k, k + 1n)`, `(k, k, 1n)`, `(k, k, k + 1n)`) right-nests
both. Close with `{==}`.
