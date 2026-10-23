The reference matches on `n` and then on `k`. For `n = 0n`: `1n` at `k = 0n`,
`0n` at a successor. For a successor `n`: `1n` at `k = 0n`, and at a successor
`k` it is `Nat.add(choose(p, k), choose(p, Nat.sub(k, 1n)))`. `k` is used twice
in that step, so declare `+k`, and use `Nat.sub(k, 1n)` for its predecessor.

- `choose_zero_left`, `choose_step`, `choose_five_two`: close by `{==}`; the
  arguments are constructors or literals, so both matches step.
- `choose_zero_right`: match on `n`, and each case closes by `{==}` (the `0n`
  case reaches `1n` through the outer match, the successor case through the
  inner match on `0n`). No hypothesis is needed.
