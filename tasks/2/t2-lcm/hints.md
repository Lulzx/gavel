The walk takes the budget first because it is the shrinking argument. `c`,
`step` and `m` are each used several times, so all are `+`.

The reference `lcm_go` matches on `fuel`: `0n` answers `c`, and `1n++f` answers
`Bool.pick(Nat, P.divides(c, m), c, lcm_go(f, c + step, step, m))`. The test is
a `Bool` term because a `match` cannot scrutinise a computed value. `lcm`
matches on `n` then `m`: either `0n` answers `0n`, and `1n++p`, `1n++q` answer
`lcm_go(1n + q, 1n + p, 1n + p, 1n + q)`. The budget `m` is enough because the
multiplier needed is at most `m`.

All ten laws close by `{==}`, with no lemma and no induction:

- `lcm_zero_left`, `lcm_handoff`, `lcm_go_no_fuel`, `lcm_go_step`: the matched
  argument is a literal or `1n + _`, so the match steps.
- `lcm_zero_right` matches on `n` (no recursion): `0n` and `1n+np` are both
  `{==}`, the second because the inner match reads the literal `0n`.
- the five closed laws compute out the walk.
