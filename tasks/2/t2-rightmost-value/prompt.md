Implement `rightmost_value` on the prelude's tree, then prove the three laws
about it.

`prelude.bend` declares the tree: a `P.Leaf{v}` carries a value, and a
`P.Node{l, key, r}` carries a key of its own between its two subtrees. Every
node carries a number, so a tree has a number at each of its leaves and one more
at every interior node.

`rightmost_value(t)` must return the value the tree's **rightmost leaf**
carries -- the leaf reached by descending the right subtree at every interior
node. On `P.Node{P.Leaf{1n}, 2n, P.Node{P.Leaf{3n}, 4n, P.Leaf{5n}}}` the
answer is `5n`: the walk goes right twice and stops there. An interior node's
key is not part of the answer, and neither is anything in a left subtree.

Recurse on `t`: `P.Leaf{v}` is a rightmost leaf, and answers `v`, the value it
carries. `P.Node{l, key, r}` answers whatever its right subtree answers -- the
right spine is followed and the left subtree is not read at all, because no leaf
in it is to the right of anything in `r`.

The prelude is immutable and carries two observations of the tree: `P.leftmost`,
the value at the leftmost leaf -- the same walk the other way -- and
`P.mirror`, the tree with the two subtrees swapped at every node and the keys
carried across with their nodes. Both match on their argument, so with a
variable tree neither reduces.

`rightmost_value_leaf` is definitional -- the function matches on a leaf, so
both sides are `v` -- and it is the absolute anchor: its right-hand side is a
binder and calls no target. It is also the law that says the answer is a value
the tree *carries*: a body that answered a count, or a constant, is caught only
here, because the step law below is stated at a `P.Node` and never reaches a
leaf.

`rightmost_value_node` is definitional too, and it is the step. It says the walk
descends the right subtree and nothing else: a body that answered the node's own
key, or that descended the left subtree, or that added the two subtrees, leaves
the two sides unconvertible.

`rightmost_value_mirror` is the law with content, and the only one that is not
an unfolding. Mirroring swaps the two sides of every node, so the rightmost leaf
of the mirror is the leftmost leaf of the tree: the answer at `P.mirror(t)` is
`P.leftmost(t)`. Its tree is a variable, so `P.mirror` and `P.leftmost` are both
stuck and the case split on the tree is the proof. It is stated against the
prelude's own observations rather than against the recursion, so a body that got
the direction of the walk wrong -- which the two laws above already separate --
is caught here a second time, and a body that read a value anywhere other than
the end of the right spine leaves the two sides unconvertible.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.rightmost_value_leaf(v)`, `def L.rightmost_value_node(l, key, r)` and
`def L.rightmost_value_mirror(t)`. Helpers go under the reserved `Policy.`
namespace, which the gate ignores, and none of them may cite a law.
