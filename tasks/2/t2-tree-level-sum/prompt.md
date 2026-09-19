Implement `tree_level_sum` on trees of `Nat`, then prove the four laws about it.

`prelude.bend` declares the tree: a `P.Leaf{v}` carries a value, and a
`P.Node{l, key, r}` carries a key of its own between its two subtrees. Every
node carries a value, so a level sum is a sum over both kinds.

`tree_level_sum(t, k)` is the sum of the values the tree carries at depth `k`,
counting the root as depth `0n`, and `0n` wherever the tree is shallower than
`k`. So on `P.Node{P.Leaf{1n}, 2n, P.Leaf{3n}}` it answers `2n` at depth `0n`
(the node's key), `4n` at depth `1n` (the two leaves), and `0n` at depth `2n`.

Recurse on the tree first and on the depth second. `P.Leaf{v}` answers `v` at
depth `0n` and `0n` at every depth `1n + kp`. `P.Node{l, key, r}` answers `key`
at depth `0n`, and otherwise hands `kp` to both subtrees and adds the two
answers.

`tree_level_sum_leaf` and `tree_level_sum_leaf_deep` are the two halves of a
leaf's answers, and they are the absolute anchors: both sides compute in each,
neither right-hand side calls `tree_level_sum`, and together they say that a
leaf's value is read at depth zero and nowhere else. A body that answered the
leaf's value at every depth satisfies the step law below, which never reaches a
leaf, and is separated by the second of these.

`tree_level_sum_node_step` is the step: below a node, depth `1n + k` is depth
`k` of both subtrees, added. Both sides compute. It is the law that says the
answer is built from both subtrees and that descending costs exactly one level.

`tree_level_sum_root` is the law with content, and the only one that is not
definitional: the depth-zero answer is the value at the root, read through
`P.root` rather than through the recursion. It is also the only law that reaches
a *node* at depth zero, so between it and the law above every constructor-depth
pair is named: a leaf at `0n` and at `1n + k` by the first two laws, a node at
`0n` by this one and at `1n + k` by the step. Its tree is a variable, so nothing
reduces and this one takes a case split on the tree.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.tree_level_sum_leaf(v)`, `def L.tree_level_sum_leaf_deep(v, k)`,
`def L.tree_level_sum_node_step(l, key, r, k)` and
`def L.tree_level_sum_root(t)`.
