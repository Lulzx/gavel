Implement `tree_fold` on the prelude's tree, then prove the laws that pin it.

The prelude declares `Tree` with a `P.Leaf{v}` carrying a number and a
`P.Node{l, r}` carrying two subtrees, and it declares `P.flatten`, the leaf
values of a tree read left to right.

`tree_fold(t, acc)` must read the leaves of `t` into the accumulator `acc`.
Recurse on `t`: a leaf returns `v <> acc`, putting its own value in front of the
accumulator, and a node returns `tree_fold(l, tree_fold(r, acc))`, folding the
right subtree first and then folding the left subtree onto the result. The
accumulator therefore comes out at the far end, with the tree's leaves in front
of it.

The law `tree_fold_leaf` is definitional: the fold matches on a leaf, so both
sides are `v <> acc`. It fixes what a leaf is worth -- a body that put the
accumulator in front of the value does not satisfy it.

The law `tree_fold_node` is definitional too, and it fixes the order: the
right subtree is folded first and the left is folded onto the result.

The law `tree_fold_flatten` is the one with content. It says the fold's answer
is `P.flatten(t)` with the accumulator on the end -- the leaves come out in the
order `P.flatten` puts them in, and the accumulator is a suffix rather than
something the fold consumes or reorders. The two definitional laws already
determine the fold; this is the statement that gives it meaning, and it is
where the work is. It is an induction in the tree, and it does not close
definitionally: after the two induction hypotheses land, one side has the two
flattened lists nested and the other has them side by side, so you need the
reassociation of `P.append`. That is a list lemma, an induction on the list
rather than on the tree, and the prelude does not supply it.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.tree_fold_leaf(v, acc)`, `def L.tree_fold_node(l, r, acc)` and
`def L.tree_fold_flatten(t, acc)`.
