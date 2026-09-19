Implement `leaf_count_at` on the prelude's tree, then prove all five laws.

`prelude.bend` declares the tree: a `P.Leaf{v}` carries a value, and a
`P.Node{l, key, r}` carries a key of its own between its two subtrees. The
number a leaf carries is a value the tree holds, not a leaf of its own: a leaf
is one leaf, and an interior node is not a leaf at all.

`leaf_count_at(t, k)` is the number of leaves in `t` at depth `k`, counting the
root as depth `0n`, and `0n` wherever the tree is shallower than `k`. So on
`P.Node{P.Leaf{1n}, 2n, P.Leaf{3n}}` it answers `0n` at depth `0n` (the root is
an interior node), `2n` at depth `1n` (the two leaves), and `0n` at depth `2n`.

Recurse on the tree first and on the depth second. `P.Leaf{v}` answers `1n` at
depth `0n` and `0n` at every depth `1n + kp`. `P.Node{l, key, r}` answers `0n` at
depth `0n`, and otherwise hands `kp` to both subtrees and adds the two answers.
Nothing in the body reads the key: a count is not a sum.

`leaf_count_at_leaf` and `leaf_count_at_leaf_deep` are the two halves of a leaf's
answers, and they are the absolute anchors: both sides compute in each, neither
right-hand side calls `leaf_count_at`, and together they say that a leaf is one
leaf at depth zero and nothing anywhere below. A body that answered the leaf's
`1n` at every depth satisfies the step law below, which never reaches a leaf,
and is separated by the second of these.

`leaf_count_at_node_step` is the step: below a node, depth `1n + k` is depth `k`
of both subtrees, added. Both sides compute. It is the law that says the answer
is built from both subtrees and that descending costs exactly one level -- a
body that descended one side only, or that carried the depth into the subtrees
unchanged, is separated here.

`leaf_count_at_root` is the law with content, and the one that observes the tree
rather than the recursion: the depth-zero answer is `1n` exactly when the root
is a leaf, read through the prelude's `P.is_leaf` and decided by `P.at_if`. It
is also the only law that reaches an interior node at depth zero, so a body that
read a subtree's answer there, or that counted the root as a leaf, is separated
by it even though every law above holds of the recursion it would take. The tree
is a variable, so nothing reduces and this one needs the case split rather than
a computation.

`leaf_count_at_mirror` is the induction: swapping the two subtrees at every node
-- which is what the prelude's `P.mirror` does -- moves every leaf to the other
side of its own level and leaves its depth alone, so the count at a depth cannot
see the difference. Its step descends into both subtrees one level below and
needs both hypotheses, which is what makes it the law that pins the descent: a
body that read only one subtree at each level agrees with every law above on
trees whose two sides happen to match, and `P.mirror` is exactly the difference
it cannot see.

Together the laws determine the body: the two halves of a leaf's answers fix the
leaf, the step fixes an interior node below the root, the root law fixes an
interior node at depth zero, and the mirror law fixes that both subtrees are
read at every step.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.leaf_count_at_leaf(v)`, `def L.leaf_count_at_leaf_deep(v, k)`, `def
L.leaf_count_at_node_step(l, key, r, k)`, `def L.leaf_count_at_root(t)` and `def
L.leaf_count_at_mirror(t, k)`.
