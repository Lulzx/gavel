The reference matches on the list: `Nil{}` answers `P.MkL{Nil{}, Nil{}}` and
`h <> t` answers `P.part_put(h, partition_below(t, n), P.le(h, n))`. The
decision `P.le(h, n)` is a computed value, so it goes through the prelude's
`P.part_put`. `xs` and `n` are declared `+`.

- `partition_below_nil`: `{==}`.
- `partition_below_keep` and `partition_below_drop`: the goal is stuck on the
  `Bool`. Flip the hypothesis with `Equal.sym(Bool, P.le(h, n), True{}, e)`
  (`False{}` and `y` for drop) and rewrite with the hole in the decision slot of
  `P.part_put`, then `{==}`.
- `partition_below_len`: induction on `xs`, with `Policy.` lemmas:
  - `add_succ_right(a, b)`: `{a + (1n + b) == 1n + (a + b) : Nat}`, by induction
    on `a`.
  - `part_step_len(h, t, +p, k, ih)`: given
    `ih : P.len(P.front(p)) + P.len(P.back(p)) == P.len(t)`, the same sum for
    `P.part_put(h, p, k)` is `1n + P.len(t)`. A match on the `Bool` `k`: `True{}`
    rewrites with `%ih` then `{==}`; `False{}` first moves the `1n` out with
    `add_succ_right` (flipped), then `%ih`.

  `Nil{}` is `{==}`; the cons case calls `part_step_len(h, t, partition_below(t, n),
  P.le(h, n), L.partition_below_len(t, n))`.
