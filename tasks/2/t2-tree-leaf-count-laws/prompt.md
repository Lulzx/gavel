Implement `tree_leaf_count` on the prelude's tree, then prove the laws that pin
it.

The prelude declares `Tree` with a `P.Leaf{v}` carrying a number and a
`P.Node{l, r}` carrying two subtrees, and it declares `P.flatten`, the values at
the leaves read left to right, and `P.len`, the length of a list.

`tree_leaf_count(t)` must return the number of leaves in `t`. The number at a
leaf is a value the tree carries, not a leaf of its own: a leaf is one leaf, and
an interior node is not a leaf at all. Recurse on `t`: `P.Leaf{v}` returns `1n`;
`P.Node{l, r}` returns `tree_leaf_count(l) + tree_leaf_count(r)`, contributing
nothing of its own. Nothing here reads the value at a leaf.

The law `tree_leaf_count_leaf` is definitional -- the function matches on a
leaf, so both sides are `1n` -- and it is the anchor. The step law below is
stated at `P.Node{l, r}`, so it never reaches a leaf, and a body whose leaf case
answered anything but `1n` -- `0n`, or the value the leaf carries, or one more
-- is caught only here. It is the one law in the set whose right-hand side does
not call `tree_leaf_count` itself.

The law `tree_leaf_count_node` is definitional too, and it is the law that says
the answer comes from *both* subtrees and that a node is not counted: a body
that descended one side only is separated here on any tree whose subtrees
differ, and a body that added `1n` for each interior node answers one more here
on every input with a node.

The law `tree_leaf_count_flatten` is the one with content. It says the count is
how many values `P.flatten` lists. Because `P.flatten` reads the values the
leaves carry -- and lists none of the interior nodes -- this is the law that
separates the count from its exact complement, the number of interior nodes,
even though that complement satisfies the step law above with its own recursion.
It is stated without naming any of the recursion's cases. It is an induction in
the tree and it does not close definitionally: after the two induction
hypotheses land, one side has the two counted lists added and the other has them
appended, so you need the fact that the length of `P.append` is the sum of the
lengths. That is a list lemma -- an induction on the list rather than on the
tree -- and the prelude does not supply it.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.tree_leaf_count_leaf(v)`, `def L.tree_leaf_count_node(l, r)` and
`def L.tree_leaf_count_flatten(t)`.
