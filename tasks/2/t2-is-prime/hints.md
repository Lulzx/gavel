`no_divisor(+n, +k)` is the walk. It matches on `k` (the shrinking argument; `n` is
passed on unchanged): `0n` answers `True{}`; `1n+kp`
matches on `kp`: `0n` answers `True{}`, and `1n+j` answers
`Bool.and(Bool.not(P.divides(n, k)), no_divisor(n, kp))`. The test is a `Bool`
term because a `match` cannot scrutinise a computed value.

`is_prime(+n)` matches on `n` twice: `0n` and `1n+0n` answer `False{}`, and
`1n+1n+q` answers `no_divisor(n, 1n + q)`, the walk from `n - 1n`.

All ten laws close by `{==}`, with no lemma and no induction:

- `no_divisor_zero`, `no_divisor_one`: the second argument is a literal that
  hits a stop arm.
- `no_divisor_step`: `2n + j` unfolds to `1n + (1n + j)`, so both matches step.
- `is_prime_handoff`: `2n + n` unfolds to `1n + (1n + n)`, so both matches step.
- the six closed laws (`is_prime_zero` ... `is_prime_nine`): both sides are
  numerals, so the walk computes.
