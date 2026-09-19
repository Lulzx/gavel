Implement `same_shape` on two trees of `Nat`, then prove the six laws about it.

`same_shape(t1, t2)` answers whether `t1` and `t2` are built the same way,
ignoring the values they carry: two leaves have the same shape, a leaf against
a node does not, and two nodes have the same shape exactly when both pairs of
their subtrees do. The answer is a `Bool`, not a tree and not a count. A tree
whose leaves carry different numbers from another's is the *same shape* as it;
a tree with one more level is not.

The trees are the prelude's `P.Tree`: a `P.Leaf{v}` carries a value and a
`P.Node{l, key, r}` carries a key and two subtrees. `P.Tree` is `Data`, and the
constructors are reached through the prelude alias in patterns and in terms
alike.

Walk both trees at once: two leaves answer `True{}`, a leaf against a node --
either way round -- answers `False{}`, and two nodes answer the `Bool.and` of
the two subtree comparisons. Recurse on the first tree and step the second
alongside it.

The prelude is immutable and carries the tree type and one helper the last law
is stated in: `P.relabel(t)` is `t` with every value moved on by one, a leaf's
value and an interior key alike, and the shape untouched.

The four laws `same_shape_leaf_leaf`, `same_shape_leaf_node`,
`same_shape_node_leaf` and `same_shape_node_node` fix the walk at every pair of
constructors. The first is the absolute anchor -- its right-hand side is
`True{}`, which calls no target -- and the fourth is the definition written
out, with the two keys bound and never read.

`same_shape_relabel` is the law with content: relabelling every value does not
change the shape, so its right-hand side is `True{}` at every tree. A body that
compared the values, at a leaf or at an interior key, satisfies the four laws
above and is separated here. `same_shape_self` says a tree has the same shape
as itself at every tree, including the ones no relabelling builds. Both are
inductive in `t`, because `P.relabel` and the walk both match on their argument
and a variable does not reduce.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.same_shape_leaf_leaf(v, w)`, `def L.same_shape_leaf_node(v, l, key, r)`,
`def L.same_shape_node_leaf(l, key, r, w)`, `def
L.same_shape_node_node(l1, k1, r1, l2, k2, r2)`, `def L.same_shape_relabel(t)`
and `def L.same_shape_self(t)`. Helpers go under the reserved `Policy.`
namespace, which the gate ignores, and none of them may cite a law.
