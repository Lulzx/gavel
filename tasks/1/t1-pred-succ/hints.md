The reference matches on its argument: `add` answers `b` for `0n` and
`1n + add(p, b)` for `1n+p`; `pred` answers `0n` for `0n` and `p` for `1n+p`.

- `pred_succ` and `pred_zero` close by `{==}`: `pred` steps on a literal.
- `add_zero` and `add_succ` are each exactly the statement of a `Policy.`
  lemma, so the law's proof is just a call to it. Both lemmas are inductions on
  the first argument (`0n` case `{==}`; in the `1n+p` case rewrite with the
  hypothesis at `p`, hole in `1n + _`, then `{==}`):
  `Policy.add_zero(x) : S.add(x, 0n) == x`, and
  `Policy.add_succ(a, b) : S.add(a, 1n+b) == 1n + S.add(a, b)` (the induction
  is on `a`, with `b` carried along).
- `pred_add_one` is an induction on `x` whose step is not the hypothesis. The
  `0n` case is `{==}`. In the `1n+p` case the goal reduces to
  `S.add(p, 1n) == 1n+p`, so it needs
  `Policy.add_one_comm(x) : S.add(x, 1n) == 1n + x`, another induction on `x`
  of the same shape. Rewrite with `Policy.add_one_comm(p)` (goal
  `S.add(p, 1n) == _`), then `{==}`.
