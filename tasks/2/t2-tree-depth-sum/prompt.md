Implement `tree_depth_sum`, then prove the three laws in `LAWS.bend`.

The prelude's `P.Tree` is either `P.Leaf{v}`, a leaf carrying a `Nat`, or
`P.Node{l, key, r}`, a node with a key and two subtrees. Leaves and nodes both
count as nodes of the tree.

`tree_depth_sum(t, k)` is the sum of the depths of all the nodes of `t`, where
the root of `t` is taken to be at depth `k`, and each step down to a child adds
one. The values and keys do not matter, only where the nodes sit. With `k` equal
to `0n` this is the plain sum of depths.

    tree_depth_sum(P.Leaf{7n}, 3n) == 3n
    tree_depth_sum(P.Node{P.Leaf{1n}, 2n, P.Leaf{3n}}, 0n) == 2n
    tree_depth_sum(P.Node{P.Leaf{1n}, 2n, P.Leaf{3n}}, 5n) == 17n

- `tree_depth_sum_leaf`: a leaf at depth `k` contributes `k`, whatever its value.
- `tree_depth_sum_node`: a node at depth `k` contributes `k`, plus the sum for
  its left subtree at depth `1n + k`, plus the sum for its right subtree at
  depth `1n + k`.
- `tree_depth_sum_three`: for the tree `P.Node{P.Leaf{1n}, 2n, P.Leaf{3n}}` at
  depth `0n` the sum is `2n`.
