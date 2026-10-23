The reference matches on the list: `Nil{}` answers `P.MkL{Nil{}, Nil{}}` and
`h <> t` answers `P.span_put(h, t, span_below(t, n), P.le(h, n))`. The decision
`P.le(h, n)` is a computed value, so it goes through the prelude's
`P.span_put`. `xs` and `n` are declared `+`.

- `span_below_nil`: `{==}`.
- `span_below_keep` and `span_below_stop`: the goal is stuck on the `Bool`.
  Flip the hypothesis with `Equal.sym(Bool, P.le(h, n), True{}, e)` (`False{}`
  and `y` for stop) and rewrite with the hole in the decision slot of
  `P.span_put`, then `{==}`.
- `span_below_len`: induction on `xs`, via one `Policy.` lemma
  `span_step_len(h, t, p, k, ih)`: given
  `ih : P.len(P.front(p)) + P.len(P.back(p)) == P.len(t)`, the same sum for
  `P.span_put(h, t, p, k)` is `1n + P.len(t)`. A match on the `Bool` `k`:
  `True{}` rewrites with `%ih` (`{1n + (P.len(P.front(p)) + P.len(P.back(p))) == 1n + _ : Nat}`)
  then `{==}`; `False{}` is `{==}`. `Nil{}` is `{==}`; the cons case calls
  `span_step_len(h, t, span_below(t, n), P.le(h, n), L.span_below_len(t, n))`.
