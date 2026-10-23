The reference matches on `a` and then on `b`: `0n` against `0n` answers
`P.Eq{}`, `0n` against a successor `P.Lt{}`, a successor against `0n` `P.Gt{}`,
and two successors answer `cmp(p, q)` on the predecessors.

- `cmp_zero_zero`, `cmp_zero_succ`, `cmp_succ_zero`, `cmp_succ_succ`: each
  closes by `{==}`.
- `cmp_self`: induction on `a`. The `0n` case is `{==}`. In the `1n+p` case
  `cmp(1n + p, 1n + p)` steps to `cmp(p, p)`, which is exactly the hypothesis,
  so the answer is the bare call `L.cmp_self(p)` with no rewrite.
- `cmp_antisym`: match on `a`, then on `b`. Three of the four cases (`0n`/`0n`,
  `0n`/successor, successor/`0n`) close by `{==}`, with `P.flip` reducing. The
  successor/successor case steps both calls and is the bare hypothesis
  `L.cmp_antisym(p, q)`.
