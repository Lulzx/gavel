The reference is a pair of matches. `argmax_go` matches on `xs`: `Nil{}` answers
`bi`, and a cons `+h <> t` recurses with
`P.max2(h, cur), P.pick_if(P.gt(h, cur), i, bi), 1n + i`. `cur`, `i` and `h` are
used twice, so declare `+cur`, `+i` and bind `+h`. The decision goes through
`P.pick_if` because a match cannot scrutinise `P.gt(...)`. `argmax` answers `0n`
on `Nil{}` and `argmax_go(t, h, 0n, 1n)` on `h <> t`.

Six laws close by `{==}`: `argmax_nil`, `argmax_cons`, `argmax_go_nil`,
`argmax_go_step`, `argmax_three` and `argmax_tie` (the last two are closed lists,
so everything computes).

`argmax_same` is an induction on `n`; the `0n` case is `{==}`. In the `1n+p`
case every element ties with `k`, so the stuck terms are `P.max2(k, k)` and
`P.gt(k, k)`. Two `Policy.` lemmas, each an induction on `k`:

- `gt_irrefl(k)`: `P.gt(k, k) == False{}`.
- `max2_self(k)`: `P.max2(k, k) == k`. Its step needs `Equal.sym` on the
  hypothesis.

Rebind `+r = k` since `k` is used by both lemmas and the hypothesis. Rewrite
(each lemma flipped with `Equal.sym`) `max2(r, r)` to `r`, then `gt(r, r)` to
`False{}`, so `pick_if(False{}, i, bi)` reduces to `bi`; then apply the
hypothesis `L.argmax_same(p, r, bi, 1n + i)`, also flipped, and close by `{==}`.
