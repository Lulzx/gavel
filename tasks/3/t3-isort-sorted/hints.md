A `match` cannot scrutinise `P.le(y, h)`, so the reference defers the decision:
`insert` answers `y <> Nil{}` on `Nil{}` and `P.insert_put(t, h, y, P.le(y, h))`
on `+h <> t`; `isort` answers `Nil{}` and `insert(isort(t), h)`.

- `insert_le`, `insert_gt`, `isort_swap`: the list is a literal, so the goal
  computes to `P.insert_put(Nil{}, ..., _)` with the decision in the hole;
  rewrite it with `e` (flipped) and close by `{==}`.
- `insert_len`: match on `xs` (no induction in the law). `Nil{}` is `{==}`; the
  cons case rewrites with a `Policy.` lemma
  `P.len(P.insert_put(t, h, y, k)) == 1n + (1n + P.len(t))`, which is an
  induction on `t` with a match on `k` (the cons/`False{}` case rewrites with
  the hypothesis at `(t2, h2, y, P.le(y, h2))`, flipped, under `1n + _`).
- `insert_sorted`: match on `xs`. `Nil{}` is `{==}`; the cons case is the
  general lemma `H` below at `(t, h, y, P.le(y, h), 0n, P.le(0n, h), {==}, {==}, {==}, e)`.
- `isort_sorted`: induction on `xs`. The cons case is
  `Policy.ins_top(S.isort(t), h, L.isort_sorted(t))`, where `ins_top` matches
  its list and calls `H` the same way (it cannot cite `insert_sorted`).

The `Policy.` lemmas:

- `absurd_true(x, e: {False{} == True{}}) -> {x == True{}}`: `Equal.cong` of
  `e` along `b => Policy.bool_ite(b, x)`, where `bool_ite` answers `True{}` on
  `True{}` and `x` on `False{}`.
- `le_flip(a, b, +e: {P.le(a, b) == False{}}) -> {P.le(b, a) == True{}}`:
  induction on `a`, match on `b`; the `0n` case is a contradiction via
  `absurd_true`.
- `H(t, +h, +y, k, +p, c, e_k: {k == P.le(y, h)}, e_c: {c == P.le(p, h)}, e_py: {P.le(p, y) == True{}}, es: {P.sorted_put(t, h, c) == True{}})`
  proves `P.sorted_put(P.insert_put(t, h, y, k), p, True{}) == True{}`:
  inserting into a sorted `h <> t` whose lower bound is `p`, with `p` at most
  `y`, stays sorted above `p`. Match `t`, then `k`, then `c` where needed.
  Every `c == False{}` cell is absurd from `es`. The other cells rewrite the
  decisions with `e_py`, `e_k`, `e_c` and `le_flip(y, h, ...)`; the
  cons/`False{}`/`True{}` cell recurses with
  `H(t2, h2, y, P.le(y, h2), h, P.le(h, h2), {==}, {==}, le_flip(...), es)`.
  A contradiction must stay inside `P.sorted_put`: the checker does not unfold
  a def whose scrutinee is stuck, so different predicates on a stuck list never
  meet.
