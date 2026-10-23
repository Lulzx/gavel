The reference has two defs. `distinct_go(xs, +seen)` matches on `xs`: `Nil{}`
answers `Nil{}`, and `+h <> t` answers
`P.skip_if(P.mem(seen, h), h, distinct_go(t, h <> seen))`. `distinct` matches on
its list: `Nil{}` answers `Nil{}` and `+h <> t` answers
`h <> distinct_go(t, h <> Nil{})`. The test goes through `P.skip_if` because a
`match` cannot scrutinise a computed value.

- `distinct_nil`, `distinct_cons`, `distinct_go_nil`, `distinct_go_step` and
  `distinct_nonadjacent` all close by `{==}`; the last is a closed computation.
- `Policy.eq_refl(k) : P.eq(k, k) == True{}`: match on `k`; `0n` is `{==}`, and
  `1n+p` rewrites with `Policy.eq_refl(p)` then `{==}`.
- `Policy.mem_head(seen, k) : P.mem(k <> seen, k) == True{}`: flip `eq_refl`
  with `Equal.sym` and rewrite the hole in `P.or_if(_, P.mem(seen, k))`, then
  `{==}`.
- `distinct_same_seen` is an induction on `n`. `0n` is `{==}`. In the `1n+p`
  case rebind `+r = k` and `+s = seen`, rewrite the test to `True{}` with the
  flipped `mem_head(s, r)`, so `P.skip_if(True{}, ...)` drops the head, then
  rewrite the remaining walk to `Nil{}` with the hypothesis
  `L.distinct_same_seen(p, r, r <> s)` (flipped with `Equal.sym`), then `{==}`.
- `distinct_same` matches on `m`: `0n` is `{==}`; in `1n+p` rebind `+r = k`,
  rewrite with the flipped `mem_head(Nil{}, r)`, then with the flipped
  `L.distinct_same_seen(p, r, r <> Nil{})`, then `{==}`. It needs no induction.
