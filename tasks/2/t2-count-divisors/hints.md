The reference `cd_go` matches on `k`: `0n` answers `0n`, and `1n+kp` answers
`Bool.pick(Nat, P.divides(n, k), 1n, 0n) + cd_go(n, kp)`. The test is a `Bool`
term passed to `Bool.pick` because a match cannot scrutinise the remainder.
`n` and `k` are read several times, so declare `+n` and `+k`. `count_divisors(n)`
has no match of its own: it is `cd_go(n, n)`, with `+n`.

All six laws close by `{==}` and need no rewrite or lemma: `cd_go_zero` has a
literal `0n`; `cd_go_step` has a successor `1n + k`; `count_divisors_handoff`
is the unfolding of the def; and the last three are closed numerals that the
checker computes.
