The reference matches on the tree, then on the depth. `P.Leaf{v}`: `0n` answers
`1n`, `1n+kp` answers `0n`. `P.Node{l, key, r}`: `0n` answers `0n`, and `1n++kp`
answers `leaf_count_at(l, kp) + leaf_count_at(r, kp)`.

- `leaf_count_at_leaf`, `leaf_count_at_leaf_deep` and `leaf_count_at_node_step`
  close by `{==}`.
- `leaf_count_at_root` is a match on `t` (no recursion): the `P.Leaf{v}` and
  `P.Node{l, key, r}` cases are both `{==}`.
- `leaf_count_at_mirror` is an induction on `t`, with a split on `k` in the node
  case. Leaf is `{==}` (mirror of a leaf is that leaf). Node, `k = 0n` is
  `{==}`. Node, `1n++kp`: the left side is the two subtrees' counts swapped, so
  rewrite each mirrored count back with the flipped hypotheses at `r` and `l`
  (`Equal.sym(Nat, S.leaf_count_at(P.mirror(r), kp), S.leaf_count_at(r, kp), L.leaf_count_at_mirror(r, kp))`
  and the same for `l`), then swap the summands with the flipped
  `Policy.add_comm`, and close with `{==}`. Bind the subtrees `+l`, `+r`.
- `Policy.add_comm(a, +b) : a + b == b + a` needs two more `Policy.` lemmas, each
  an induction on `a`: `add_zero_right(a) : a == a + 0n` and
  `add_succ_right(a, -b) : a + (1n + b) == 1n + (a + b)`. `add_comm` is itself
  an induction on `a`: `0n` rewrites with `add_zero_right(b)`; `1n+p` rebinds
  `+p = p`, rewrites with the flipped `add_succ_right(b, p)` and then
  `add_comm(p, b)`.
