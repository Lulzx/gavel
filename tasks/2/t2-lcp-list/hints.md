The reference matches on `xs`, then on `ys`: either `Nil{}` answers `Nil{}`, and
`+h <> t` with `k <> u` answers
`P.gate_list(P.is_eq(h, k), h <> lcp_list(t, u))`. The comparison goes through
`P.gate_list` because a `match` cannot scrutinise a computed value. The head is
bound `+h` since it is used twice.

- `lcp_list_nil_left`, `lcp_list_cons_heads` and the two closed laws close by
  `{==}`.
- `lcp_list_nil_right` is a match on `xs` (no recursion): `Nil{}` and `+h <> t`
  are both `{==}`.
- `Policy.is_eq_self(x) : 1n == P.is_eq(x, x)`, with `1n` on the left so it can
  rewrite the goal: induction on `x`; `0n` is `{==}`; `1n+p` rewrites with
  `Policy.is_eq_self(p)` then `{==}`.
- `lcp_list_self` is an induction on `xs` (heads bound `+h`, tail `+t`).
  `Nil{}` is `{==}`. In the cons case, rewrite the tails' prefix to `t` with
  the flipped hypothesis `Equal.sym(List<&2, Nat>, S.lcp_list(t, t), t, L.lcp_list_self(t))`,
  then `P.is_eq(h, h)` to `1n` with `Policy.is_eq_self(h)`; the gate reduces and
  `{==}` closes it.
