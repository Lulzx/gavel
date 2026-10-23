The reference matches on `n` in both defs. `count_up`: `0n` answers `Nil{}`, and
`1n++k` answers `P.snoc(count_up(k), k)`. `count_down`: `0n` answers `Nil{}`,
and `1n++k` answers `k <> count_down(k)`. `k` is used twice, so the successor
pattern is the reusable `1n++k`.

- `count_up_zero`, `count_up_succ`, `count_down_zero`, `count_down_succ`: close
  by `{==}`.
- `len_count_down`: induction on `n`; `0n` is `{==}`; the step rewrites with the
  hypothesis at `k`, goal `{1n + P.len(S.count_down(k)) == 1n + _ : Nat}`, then
  `{==}`.
- `len_count_up` and `count_up_rev_count_down` both need a `Policy.` lemma about
  `P.snoc`, each an induction on the list `xs` (declared `+xs`):
  - `len_snoc(+xs, y)`: `P.len(P.snoc(xs, y)) == 1n + P.len(xs)`; the step
    rewrites with the hypothesis at `t`, goal `{1n + P.len(P.snoc(t, y)) == 1n + _ : Nat}`.
  - `rev_snoc(+xs, y)`: `P.rev(P.snoc(xs, y)) == y <> P.rev(xs)`; the step flips
    the hypothesis with `Equal.sym`, goal `{P.snoc(_, h) == y <> P.snoc(P.rev(t), h) : List<&2, Nat>}`.

  Then `len_count_up` (induction on `n`) flips `len_snoc(count_up(k), k)` with
  `Equal.sym`, goal `{_ == 1n + k : Nat}`, then rewrites with the hypothesis at
  `k`, goal `{1n + P.len(S.count_up(k)) == 1n + _ : Nat}`. And
  `count_up_rev_count_down` (induction on `n`) flips `rev_snoc(count_up(k), k)`
  with `Equal.sym`, goal `{_ == k <> S.count_down(k) : List<&2, Nat>}`, then
  rewrites with the hypothesis at `k`, goal
  `{k <> P.rev(S.count_up(k)) == k <> _ : List<&2, Nat>}`.
