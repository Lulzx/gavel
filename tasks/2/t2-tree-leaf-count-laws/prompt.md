Implement `tree_leaf_count`, then prove the three laws in `LAWS.bend`.

The prelude's `P.Tree` is either `P.Leaf{v}`, a leaf carrying a `Nat`, or
`P.Node{l, r}`, a node with two subtrees.

`tree_leaf_count(t)` is the number of leaves of `t`. A leaf counts once whatever
value it carries, and a node counts for nothing itself.

    tree_leaf_count(P.Leaf{9n}) == 1n
    tree_leaf_count(P.Node{P.Leaf{1n}, P.Leaf{2n}}) == 2n
    tree_leaf_count(P.Node{P.Node{P.Leaf{1n}, P.Leaf{2n}}, P.Leaf{3n}}) == 3n

The laws use the prelude's `P.flatten(t)`, the leaf values of `t` read left to
right, and `P.len(xs)`, the number of elements of `xs`.

- `tree_leaf_count_leaf`: a leaf has `1n` leaf, whatever its value.
- `tree_leaf_count_node`: the leaf count of `P.Node{l, r}` is the leaf count of
  `l` plus the leaf count of `r`.
- `tree_leaf_count_flatten`: the leaf count of `t` is the length of
  `P.flatten(t)`.
