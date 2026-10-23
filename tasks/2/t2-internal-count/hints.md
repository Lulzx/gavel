The reference matches on the tree: `P.Leaf{v}` answers `0n`, and
`P.Node{l, key, r}` answers `1n + internal_count(l) + internal_count(r)`.

- `internal_count_leaf` and `internal_count_node` close by `{==}`.
- `internal_count_inner` is an induction on `t` (calls itself on `l` and `r`).
  The leaf case is `{==}`. The node case needs a `Policy.` lemma
  `len_append(xs, ys) : P.len(xs) + P.len(ys) == P.len(P.append(xs, ys))`,
  proved by induction on `xs` (cons case: rewrite with `len_append(t, ys)` under
  `1n +`, then `{==}`). In the node case, bind the subtrees reusable
  (`P.Node{+l, key, +r}`), then rewrite three times and close with `{==}`:
  with `Policy.len_append(P.inner(l), P.inner(r))`, then with
  `L.internal_count_inner(l)`, then with `L.internal_count_inner(r)`, each with
  the goal written out around a `_`.
