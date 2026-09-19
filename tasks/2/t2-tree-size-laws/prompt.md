Implement `tree_size` on the prelude's tree, then prove the laws that pin it.

The prelude declares `Tree` with a `P.Leaf{v}` carrying a number and a
`P.Node{l, key, r}` carrying a key between two subtrees, and it declares
`P.nodes`, the values the tree carries read root first, and `P.len`, the length
of a list.

`tree_size(t)` must return the number of nodes in `t`, counting both the leaves
and the interior nodes. Recurse on `t`: `P.Leaf{v}` is a single node and returns
`1n`; `P.Node{l, key, r}` is itself one node in addition to the nodes of its two
subtrees, and returns `1n + tree_size(l) + tree_size(r)`. The key at a node is
not counted and not read.

The law `tree_size_leaf` is definitional -- the function matches on a leaf, so
both sides are `1n` -- and it is the anchor. The step law below is stated at
`P.Node{l, key, r}`, so it never reaches a leaf, and a body whose leaf case
answered anything but `1n` is caught only here. It is also the one law in the
set whose right-hand side does not call `tree_size` itself.

The law `tree_size_node` is definitional too, and it is the law that says the
answer comes from *both* subtrees: a body that descended one side only agrees
with the third law below on any tree whose subtrees agree and is separated here.

The law `tree_size_nodes` is the one with content. It says the size is how many
entries `P.nodes` lists -- one entry for the key of each `Node` and one for the
value of each `Leaf`. Because `P.nodes` reads every node's own value, this is
the law that separates a body that counted only the leaves from one that counted
only the interior nodes, and it is stated without naming any of the recursion's
cases. It is an induction in the tree and it does not close definitionally:
after the two induction hypotheses land, one side has the two counted lists
added and the other has them appended, so you need the fact that the length of
`P.append` is the sum of the lengths. That is a list lemma -- an induction on the
list rather than on the tree -- and the prelude does not supply it.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.tree_size_leaf(v)`, `def L.tree_size_node(l, key, r)` and
`def L.tree_size_nodes(t)`.
