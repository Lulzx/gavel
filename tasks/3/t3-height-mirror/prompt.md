Implement `height`, then prove the three laws in `LAWS.bend`.

The prelude's `P.Tree` is a binary tree with no values: `P.Leaf{}` or
`P.Node{l, r}`. `height(t)` is the number of edges on the longest path from the
root to a leaf: `0n` for a leaf, and one more than the larger of the two
subtrees' heights for a node.

    height(P.Leaf{}) == 0n
    height(P.Node{P.Node{P.Leaf{}, P.Leaf{}}, P.Leaf{}}) == 2n

The laws use the prelude's `P.mirror(t)`, the tree with the two subtrees
swapped at every node, and `P.max(a, b)`, the larger of two numbers.

- `height_leaf`: a leaf has height `0n`.
- `height_node`: the height of `P.Node{l, r}` is `1n` plus `P.max` of the
  heights of `l` and `r`.
- `height_mirror`: mirroring a tree does not change its height.
