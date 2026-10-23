The reference matches on the fuel first, so the recursion consumes a structural
argument and the number is carried along: `0n` answers `0n`; on `1n+f` it
matches on `n`, with `0n` and `1n+0n` answering `0n` and `1n+1n+p` answering
`1n + collatz_len(f, Bool.pick(Nat, P.is_even_b(n), P.half(n), Nat.mul(3n, n) + 1n))`.
`n` is read in several places, so declare `+n`.

Every law closes by `{==}`; none needs a rewrite or a lemma.

- `collatz_len_no_fuel`: the fuel is the literal `0n`.
- `collatz_len_zero` and `collatz_len_one`: the number is a literal but the fuel
  is a variable, so match on `f`; both cases close by `{==}` (the fuel match
  answers `0n`, or the number match does).
- `collatz_len_step`: both matches step, and the step term is carried unchanged
  on both sides, since the parity test and the halving are stuck on the
  variable `p`.
- `collatz_len_six`, `collatz_len_fifteen`: closed terms, so the whole walk
  computes.
