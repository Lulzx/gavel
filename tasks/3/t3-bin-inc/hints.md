The reference matches on the list, then on the head bit: `Nil{}` answers
`P.I{} <> Nil{}`, `P.O{} <> t` answers `P.I{} <> t`, and `P.I{} <> t` answers
`P.O{} <> inc_bin(t)`.

- `inc_bin_nil` and `inc_bin_zero`: both sides compute, so `{==}`.
- `to_nat_inc`: the reference proves it as a `Policy.` copy of the statement,
  `Policy.to_nat_inc_general(+bs)`, by induction on `bs`, then the law is one
  rewrite with that lemma and `{==}`. In the lemma, `Nil{}` and the `P.O{}` case
  close by `{==}`. The `P.I{}` case is the carry: the goal reduces to

      P.to_nat(S.inc_bin(t)) + P.to_nat(S.inc_bin(t)) == 2n + (P.to_nat(t) + P.to_nat(t))

  (after `P.double` unfolds). `S.inc_bin(t)` cannot reduce, so rewrite each of
  its two occurrences with the hypothesis at `t` (flipped with `Equal.sym`):
  first the right operand, then the left. That leaves
  `(1n + x) + (1n + x)` against `2n + (x + x)` with `x = P.to_nat(t)`, which
  after one step needs `x + (1n + x) == 1n + (x + x)`. That is a `Policy.` lemma
  `b + (1n + p) == 1n + (b + p)` (with `p` erased), by induction on `b`. Rewrite
  with it (flipped) and close by `{==}`.

The list binder is `+bs` because `P.double` uses the tail's value twice.
