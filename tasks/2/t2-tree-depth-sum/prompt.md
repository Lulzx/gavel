Implement `tree_depth_sum` on trees of `Nat`, then prove the three laws about
it.

`prelude.bend` declares the tree: a `P.Leaf{v}` carries a value, and a
`P.Node{l, key, r}` carries a key of its own between its two subtrees. Every
node carries a value; this task's answer counts where the nodes sit rather than
what they carry.

`tree_depth_sum(t, k)` adds `k` to the depth of every node of `t`. It takes the
depth of `t`'s own root as an argument rather than assuming it, so the answer at
`0n` is the sum of the depths themselves, counting the root as depth `0n`. On
`P.Node{P.Leaf{1n}, 2n, P.Leaf{3n}}` that is `2n`: the root contributes nothing
and the two leaves contribute one each.

Recurse on the tree. `P.Leaf{v}` is one node and answers `k`, whatever the value
`v` is -- the leaf's value is not part of the answer. `P.Node{l, key, r}`
answers `k` for itself, and then hands both subtrees `1n + k` and adds the two
answers: descending costs exactly one level, and both sides are walked.

`tree_depth_sum_leaf` fixes a leaf's contribution. Both sides compute, so it is
definitional, and it is the absolute anchor of the task -- its right-hand side
is the binder `k` and calls no target. It is also the law that says the nodes
are what is counted: the step law below is stated at a `P.Node`, so it never
reaches a leaf, and a body that answered the leaf's value there keeps every
other law here.

`tree_depth_sum_node` is the step. Both sides compute, so it is definitional
too, and it is where the content is: it says the node contributes its own `k`,
that both subtrees are walked rather than one, and that the depth they are
handed is `1n + k` rather than `k`. A body that is a level sum -- which carries
the depth down unchanged and reads the values -- answers `k + k` for the two
subtrees here instead of `k + (1n + k)`, and is separated by this law alone.

`tree_depth_sum_three` is the closed value. The two laws above fix the walk at
every shape of argument; this one fixes, on one tree, what the walk comes to:
the root at depth zero and two leaves at depth one, so `2n`. Nothing about the
tree's keys or values reaches the answer.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.tree_depth_sum_leaf(v, k)`, `def L.tree_depth_sum_node(l, key, r, k)` and
`def L.tree_depth_sum_three()`.
