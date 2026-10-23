The reference matches on `n` in both defs. `fib_pair`: `0n` answers
`P.MkPair{0n, 1n}`, and `1n++k` answers `P.advance(fib_pair(k))`. `sum_fib`:
`0n` answers `0n`, and `1n++k` answers `P.fst(fib_pair(k)) + sum_fib(k)`.

- `fib_pair_zero`, `fib_pair_succ`, `sum_fib_zero` and `sum_fib_succ` close by
  `{==}`.
- `sum_fib_pair` is an induction on `n`; `0n` is `{==}`. In the `1n++k` case the
  goal is `(fst(fib_pair(k)) + sum_fib(k)) + 1n == snd(advance(fib_pair(k)))`.
  Two `Policy.` lemmas are needed:
  `advance_snd(p) : P.snd(P.advance(p)) == P.fst(p) + P.snd(p)` (match on `p` as
  `P.MkPair{a, b}`, then `{==}`), and
  `add_assoc(a, -b, -c) : a + (b + c) == (a + b) + c` (induction on `a`, with `b`
  and `c` erased).
  The step then rewrites with the flipped `advance_snd` to turn the right side
  into `fst + snd`, with the hypothesis `L.sum_fib_pair(k)` under the `fst`,
  and with `add_assoc(fst(fib_pair(k)), sum_fib(k), 1n)` to regroup, then `{==}`.
