The budget comes first because it is the shrinking argument (`n` is halved, a
computed term). `n` is used twice in the last branch, so it is declared `+n`.

The reference matches on `w`: `0n` answers `False{}`; `1n+p` matches on `n`:
`0n` answers `False{}`, `1n+0n` answers `True{}`, and `1n+1n+q` answers
`Bool.and(P.is_even_b(n), is_pow2(p, P.half(n)))`.

- `is_pow2_no_fuel`, `is_pow2_one`, `is_pow2_step`, `is_pow2_four` and
  `is_pow2_six` close by `{==}`: the budget is a literal or `1n + w`, and the
  number is a literal or `1n + 1n + q`, so the matches step (the last two just
  compute).
- `is_pow2_zero` is a match on `w` (it never calls itself): both `0n` and
  `1n+wp` are `{==}`, the second because the inner match reads the literal `0n`.
