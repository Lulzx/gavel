The reference matches on `xs`, then on `ys`: either `Nil{}` answers `0n`, and
`h <> t` with `k <> u` answers `P.gate(P.is_eq(h, k), 1n + lcp_len(t, u))`. The
equality test goes through `P.gate` because a `match` cannot scrutinise a
computed value.

- `lcp_len_nil_left`, `lcp_len_equal_singletons` and `lcp_len_cons` close by
  `{==}`.
- `lcp_len_nil_right` is a match on `xs` (no recursion): `Nil{}` and `h <> t`
  are both `{==}`, since the inner match on the literal `Nil{}` answers `0n`.
- `Policy.is_eq_refl(a) : 1n == P.is_eq(a, a)`, with `1n` on the left so it can
  rewrite the goal: induction on `a`; `0n` is `{==}`; `1n+p` rewrites with
  `Policy.is_eq_refl(p)` then `{==}`.
- `lcp_len_self` is an induction on `xs`. `Nil{}` is `{==}`. In the cons case,
  rewrite the tails' prefix to `P.len(t)` with the flipped hypothesis
  `Equal.sym(Nat, S.lcp_len(t, t), P.len(t), L.lcp_len_self(t))`, then replace
  `P.is_eq(h, h)` by `1n` with `Policy.is_eq_refl(h)`; the gate reduces and `{==}`
  closes it.
