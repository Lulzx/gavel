Implement `tree_level_sum`, then prove the four laws in `LAWS.bend`.

The prelude's `P.Tree` is either `P.Leaf{v}`, a leaf carrying a `Nat`, or
`P.Node{l, key, r}`, a node carrying a key between its two subtrees. Every node
carries a value: `v` for a leaf and `key` for a node.

`tree_level_sum(t, k)` is the sum of the values carried by the nodes of `t` at
depth `k`, where the root is at depth `0n` and its children at depth `1n`. It
is `0n` when the tree has no node at that depth.

    tree_level_sum(P.Node{P.Leaf{1n}, 2n, P.Leaf{3n}}, 0n) == 2n
    tree_level_sum(P.Node{P.Leaf{1n}, 2n, P.Leaf{3n}}, 1n) == 4n
    tree_level_sum(P.Node{P.Leaf{1n}, 2n, P.Leaf{3n}}, 2n) == 0n

The laws use the prelude's `P.root(t)`, the value carried by the root of `t`.

- `tree_level_sum_leaf`: a leaf at depth `0n` gives its value.
- `tree_level_sum_leaf_deep`: a leaf at depth `1n + k` gives `0n`.
- `tree_level_sum_node_step`: for a node at depth `1n + k`, the answer is the
  sum for the left subtree at depth `k` plus the sum for the right subtree at
  depth `k`.
- `tree_level_sum_root`: at depth `0n`, the answer for any tree `t` is
  `P.root(t)`.
