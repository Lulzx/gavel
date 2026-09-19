Implement `tree_max` on the prelude's tree, then prove the laws that pin it.

The prelude declares `Tree` with a `P.Leaf{v}` carrying a number and a
`P.Node{l, r}` carrying two subtrees, and it declares `P.max`, the larger of two
numbers, `P.flatten`, the values at the leaves read left to right, and
`P.max_all`, the largest element of a list with `0n` on the empty list.

`tree_max(t)` must return the largest number the tree carries. Recurse on `t`:
`P.Leaf{v}` answers the number the leaf carries, because a one-leaf tree carries
exactly that number, and `P.Node{l, r}` answers the larger of its two subtrees'
answers -- an interior node carries no number of its own, so it contributes
nothing.

The law `tree_max_leaf` is definitional -- the function matches on a leaf, so
both sides are the number the leaf carries -- and it is the anchor. The step law
below is stated at `P.Node{l, r}`, so it never reaches a leaf, and a body whose
leaf case answered anything but the leaf's own number is caught only here. It is
also the law that says the answer is a number the tree *carries* rather than a
count of anything in it.

The law `tree_max_node` is definitional too, and it is the law that says the
answer comes from *both* subtrees and that a node adds nothing: a body that
descended one side only agrees with the third law below on any tree whose
subtrees agree and is separated here.

The law `tree_max_flatten` is the one with content. It says the answer is the
largest number the tree carries, read off `P.flatten` and `P.max_all` -- neither
of which mentions `tree_max` or the recursion, so the right-hand side is an
absolute reading of the tree's own numbers rather than a relation between two of
the target's own calls. It is stated without naming any of the recursion's
cases. It is an induction in the tree and it does not close definitionally, and
it needs three arithmetic facts about `P.max` that the prelude does not have.
`P.max` steps on its first argument and then on its second, so on two variables
neither side reduces and none of the three is an unfolding.

The first is `x == P.max(x, 0n)`; the leaf case of the induction is a
one-element list, whose largest is the leaf's own number, and `P.max_all` puts
`0n` under it. The second is associativity, `P.max(P.max(a, b), c) ==
P.max(a, P.max(b, c))`: it is an induction on the first argument with a case
split on the second and then on the third, because that is how many arguments
`P.max` has to see before it reduces. The third is that `max_all` distributes
over `P.append`: the largest of `xs` appended to `ys` is the larger of their
largest, which is an induction on the list and rests on the associativity.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.tree_max_leaf(v)`, `def L.tree_max_node(l, r)` and
`def L.tree_max_flatten(t)`.
