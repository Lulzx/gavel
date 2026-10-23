Implement `tree_sum`, then prove the three laws in `LAWS.bend`.

`tree_sum(t)` is the sum of the keys of `t`: `0n` at a leaf, and at a node the
left subtree's sum plus the node's key plus the right subtree's sum.

    tree_sum(P.Leaf{}) == 0n
    tree_sum(P.Node{P.Node{P.Leaf{}, 1n, P.Leaf{}}, 2n, P.Leaf{}}) == 3n

The tree is the prelude's `P.Tree`: `P.Leaf{}` carries nothing, and
`P.Node{l, key, r}` carries a key between two subtrees. `P.mirror(t)` is `t`
with the two subtrees swapped at every node, each key staying with its node.

- `tree_sum_leaf`: a leaf sums to `0n`.
- `tree_sum_node`: a node `P.Node{l, key, r}` sums to the left subtree's sum
  plus `key`, that total then plus the right subtree's sum (the `+` groups to
  the left).
- `tree_sum_mirror`: the mirror of a tree has the same sum as the tree.
