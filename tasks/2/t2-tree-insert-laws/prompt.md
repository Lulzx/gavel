Implement `tree_insert` on the prelude's tree, then prove the laws that pin it.

The prelude declares `Tree` with a `P.Leaf{v}` carrying a number and a
`P.Node{l, r}` carrying two subtrees, and it declares `P.flatten`, the values at
the leaves read left to right, and `P.append`, one list followed by another.

`tree_insert(t, v)` must return the tree `t` with the number `v` inserted as a
new leaf immediately to the left of the leftmost leaf. Nothing is thrown away:
the number that was at that leaf is still in the tree, one level further down.
Recurse on `t`: `P.Leaf{w}` becomes `P.Node{P.Leaf{v}, P.Leaf{w}}`, the new
number to the left of the old one; `P.Node{l, r}` inserts into `l` and leaves
`r` standing, because the leftmost leaf of a node is the leftmost leaf of its
left subtree. The number being inserted is carried down unchanged rather than
being the leaf's own value, so it is a parameter of the recursion and not of any
case.

The law `tree_insert_leaf` is definitional -- the function matches on a leaf, so
both sides are the two-leaf node -- and it is the anchor. The step law below is
stated at `P.Node{l, r}`, so it never reaches a leaf, and a body whose leaf case
answered anything but that node -- the leaf it was given, or a node with the two
children the other way round -- is caught only here.

The law `tree_insert_node` is definitional too, and it is the law that says the
descent goes to the *left*: a body that descended the right subtree instead is
separated here on any tree whose subtrees differ. Together with the anchor it
determines the function on every tree.

The law `tree_insert_flatten` is the one with content. It says the numbers the
inserted tree carries are the new number and then the numbers the old tree
carried, in that order. `P.flatten` reads the leaves left to right, so the
right-hand side is an absolute reading of both trees and never mentions
`tree_insert` or its recursion. It is stated without naming any of the
recursion's cases, and it is the law that states what an insertion *means*
rather than how it is done: no number is lost and none is invented, and the new
one goes in front. It is an induction in the tree and it does not close
definitionally. After the hypothesis lands, one side has the new number in front
of the old reading and the other has it in front of the appending of the two
subtrees' readings -- the second is one unfolding of `P.append`, because its
first argument is now a cons, so no separate list lemma is needed, but the two
sides are not the same term until that unfolding happens.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.tree_insert_leaf(w, v)`, `def L.tree_insert_node(l, r, v)` and
`def L.tree_insert_flatten(t, v)`.
