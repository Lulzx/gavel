A `match` cannot scrutinise `P.le(y, h)`, so the reference defers the decision:
`insert` answers `y <> Nil{}` on `Nil{}` and `P.insert_put(t, h, y, P.le(y, h))`
on `+h <> t`; `isort` answers `Nil{}` and `insert(isort(t), h)`.

- `isort_cons`: `{==}`.
- `isort_swap`, `isort_keep`: the list is a literal, so the goal computes to
  `P.insert_put(Nil{}, y, x, P.le(x, y))`; rewrite the decision with `e`
  (flipped) and close by `{==}`.
- `insert_before`, `insert_after`: match on `t`; in each case rewrite
  `P.le(y, h)` with `e` (flipped) inside `P.insert_put(..., h, y, _)`, then
  `{==}`.
- `insert_count`: is `Policy.count_ins(xs, y, z)`, the same statement as a
  `Policy.` lemma.
- `isort_count`: induction on `xs`. In the cons case rewrite
  `P.count(z, S.insert(S.isort(t), h))` with `count_ins` (flipped), then
  `P.count(z, S.isort(t))` with the hypothesis, then `P.count(z, h <> t)` on
  the right with `count_cons` (below), and `{==}`.

The `Policy.` lemmas, all stated with the decision as a parameter:

- Arithmetic: `n + 0n == n`, `(a + b) + c == a + (b + c)`, `n + 1n == 1n + n`
  and `a + b == b + a` (induction, using the other three).
- `P.count_put(h, r, b) == P.ind(b) + r`: match on `b`. Instantiating `b` with
  a stuck `P.eq(z, h)` turns a stuck `count_put` into a sum.
- `count_cons(h, t, +z, +b, +e: {b == P.eq(z, h)})`:
  `P.count(z, h <> t) == P.ind(b) + P.count(z, t)`; match `b`, rewrite with `e`
  in each case. Call it with `b = P.eq(z, h)` and `e = {==}`.
- `cnt_ins(+t, +h, +y, k, +z)`:
  `P.count(z, P.insert_put(t, h, y, k)) == P.ind(P.eq(z, y)) + (P.ind(P.eq(z, h)) + P.count(z, t))`,
  by induction on `t` with a match on `k`. Each case rewrites the stuck
  `count_put`s with `count_put_ind`. In the `False{}` cases `h` comes out in
  front of `y`, so the two indicators are swapped with `add_assoc` and
  `add_comm`; the cons/`False{}` case also uses the hypothesis at
  `(t2, h2, y, P.le(y, h2), z)`. Rebind `+d = P.eq(z, h2)` and
  `+r = P.count(z, t2)` to keep the motives short.
- `count_ins(+xs, +y, +z)`: match `xs`; `Nil{}` uses `count_put_ind`, the cons
  case `cnt_ins(t, h, y, P.le(y, h), z)` then `count_cons`.
