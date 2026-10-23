The reference matches on the tree: `P.Leaf{v}` gives `P.Leaf{P.inc(v)}`, and
`P.Node{l, r}` gives `P.Node{tree_map(l), tree_map(r)}`.

All three laws are an induction on `t`, matching on `P.Leaf{v}` and
`P.Node{l, r}`; each binds `+t` because the node case uses subtrees twice. The
leaf case of each closes by `{==}`.

- `tree_map_leftmost`, node case: `P.leftmost` descends the left spine, so the
  goal reduces to the statement at `l`, and the proof is the hypothesis itself,
  `L.tree_map_leftmost(l)`, with no rewrite.
- `tree_map_rightmost`, node case: the same with `r`: `L.tree_map_rightmost(r)`.
- `tree_map_leaves`, node case: the goal is
  `P.leaves(tree_map(l)) + P.leaves(tree_map(r)) == P.leaves(l) + P.leaves(r)`.
  The hypotheses have the mapped count on the left, which is the side the goal
  has it on, so flip each with `Equal.sym` and rewrite one at a time:

      %Equal.sym(Nat, P.leaves(S.tree_map(l)), P.leaves(l), L.tree_map_leaves(l)) : {_ + P.leaves(S.tree_map(r)) == P.leaves(l) + P.leaves(r) : Nat}
      %Equal.sym(Nat, P.leaves(S.tree_map(r)), P.leaves(r), L.tree_map_leaves(r)) : {P.leaves(l) + _ == P.leaves(l) + P.leaves(r) : Nat}
      {==}
