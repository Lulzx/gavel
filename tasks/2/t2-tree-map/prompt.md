Implement `tree_map`, then prove the three laws in `LAWS.bend`.

The prelude's `P.Tree` is either `P.Leaf{v}`, a leaf carrying a `Nat`, or
`P.Node{l, r}`, a node with two subtrees.

`tree_map(t)` is `t` with the value at every leaf increased by one, `P.inc`. The
shape of the tree is unchanged.

    tree_map(P.Leaf{4n}) == P.Leaf{5n}
    tree_map(P.Node{P.Leaf{1n}, P.Leaf{2n}}) == P.Node{P.Leaf{2n}, P.Leaf{3n}}

The laws use four prelude names. `P.inc(x)` is `x + 1n`. `P.leftmost(t)` is the
value at the leftmost leaf of `t`, and `P.rightmost(t)` the value at the
rightmost leaf. `P.leaves(t)` is the number of leaves of `t`.

- `tree_map_leftmost`: the leftmost value of `tree_map(t)` is `P.inc` of the
  leftmost value of `t`.
- `tree_map_rightmost`: the rightmost value of `tree_map(t)` is `P.inc` of the
  rightmost value of `t`.
- `tree_map_leaves`: `tree_map(t)` has as many leaves as `t`.
