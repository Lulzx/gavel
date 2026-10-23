Implement `log2_go` and `nat_log2`, then prove the ten laws in `LAWS.bend`.

`nat_log2(n)` is the floor of the base-two logarithm of `n`: how many times `n`
can be halved (rounding down) before it reaches `1n`. Both `0n` and `1n` give
`0n`; `0n` has no logarithm and the answer there is a decision, not a
discovery.

`log2_go(w, n)` is the same count with a cap: `w` is the most halvings it may
count, so it is `nat_log2(n)` or `w`, whichever is smaller. At `w = 0n` it is
`0n`, and so it is for `n` of `0n` or `1n`.

    nat_log2(8n) == 3n
    nat_log2(7n) == 2n
    log2_go(5n, 8n) == 3n
    log2_go(1n, 8n) == 1n

The laws use `P.half(n)`, `n` divided by two, rounded down.

- `log2_go_no_fuel`: `log2_go(0n, n)` is `0n`, whatever `n` is.
- `log2_go_zero`: `log2_go(w, 0n)` is `0n`, whatever `w` is.
- `log2_go_one`: `log2_go(1n + w, 1n)` is `0n`.
- `log2_go_step`: `log2_go(1n + w, 1n + 1n + q)` is
  `1n + log2_go(w, P.half(1n + 1n + q))`.
- `nat_log2_handoff`: `nat_log2(n)` is `log2_go(n, n)`.
- `nat_log2_zero`: `nat_log2(0n)` is `0n`.
- `nat_log2_one`: `nat_log2(1n)` is `0n`.
- `nat_log2_two`: `nat_log2(2n)` is `1n`.
- `nat_log2_seven`: `nat_log2(7n)` is `2n`.
- `nat_log2_eight`: `nat_log2(8n)` is `3n`.
