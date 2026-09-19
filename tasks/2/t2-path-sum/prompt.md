Implement `path_sum` on a tree of `Nat`, then prove the five laws about it.

`path_sum(t)` adds up, over every leaf of `t`, the sum of the values on the path
from the root down to that leaf. A leaf's own value ends its path and is counted
once. An interior node's key lies on the path of every leaf beneath it, so it is
counted once per leaf under it -- a node with three leaves below contributes its
key three times. The answer is a `Nat`, not a tree and not a count: for a tree
that is one leaf, the answer is that leaf's value.

The trees are the prelude's `P.Tree`: a `P.Leaf{v}` carries a value and a
`P.Node{l, key, r}` carries a key and two subtrees. `P.Tree` is `Data`, and the
constructors are reached through the prelude alias in patterns and in terms
alike.

A leaf answers its value. A node answers the two subtrees' own sums plus its own
key multiplied by the number of leaves it has -- which is the prelude's
`P.leaves` of the left subtree plus `P.leaves` of the right one. Recurse on both
subtrees; nothing needs to be carried down, because each key's share of the
answer is decided by how many leaves sit under it rather than by its depth.

The prelude is immutable and carries the tree type, the leaf count `P.leaves(t)`
-- one for a leaf, the two subtrees' counts added at a node -- and `P.zeroed(t)`,
which is `t` with every value dropped to zero, leaf values and interior keys
alike, the shape untouched. Both match on their argument, so neither reduces at
a variable tree.

`path_sum_leaf` is the absolute anchor -- its right-hand side is the binder `v`
and calls no target -- and it is where a leaf's value enters the answer at all. A
body that answered a constant at a leaf satisfies no other law's left-hand side,
but this one is the law that fixes the base case. `path_sum_node` writes the walk
out, with both leaf counts named.

`path_sum_three` and `path_sum_deep` are closed: one tree whose subtrees are
leaves, and the same tree with a third leaf hung off the root. They fix what the
numbers come to -- `8n` and `27n` -- where the two laws above only fix the shape
of the recursion.

`path_sum_zeroed` is the law with content: a tree with every value dropped to
zero answers `0n`, at every tree. Its right-hand side calls no target, and a body
that answered anything of its own at a leaf or at an interior node is separated
here. It is inductive in `t`, because `P.zeroed` and the walk both match on their
argument and a variable does not reduce.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.path_sum_leaf(v)`, `def L.path_sum_node(l, key, r)`,
`def L.path_sum_three()`, `def L.path_sum_deep()` and
`def L.path_sum_zeroed(t)`. Helpers go under the reserved `Policy.` namespace,
which the gate ignores, and none of them may cite a law.
