Implement `internal_count` on the prelude's tree, then prove the three laws
about it.

`prelude.bend` declares the tree: a `P.Leaf{v}` carries a value, and a
`P.Node{l, key, r}` carries a key of its own between its two subtrees. The bank
calls the two kinds of node a leaf and an interior node; this task's answer
counts the second kind.

`internal_count(t)` must return how many interior nodes `t` has. A leaf is not
one of them, and the value it carries is not read; an interior node is one of
them, and its key is not read either. On
`P.Node{P.Leaf{1n}, 2n, P.Node{P.Leaf{3n}, 4n, P.Leaf{5n}}}` the answer is
`2n`: two nodes, three leaves, and nothing about the numbers.

Recurse on `t`: `P.Leaf{v}` is not an interior node and contributes `0n`;
`P.Node{l, key, r}` is one, in addition to the interior nodes of its two
subtrees, and contributes `1n + internal_count(l) + internal_count(r)`. Both
subtrees are walked -- a node is not an interior node's position.

`internal_count_leaf` is definitional -- the function matches on a leaf, so both
sides are `0n` -- and it is the absolute anchor: its right-hand side is a
literal and calls no target. The step law below is stated at `P.Node{l, key, r}`,
so it never reaches a leaf, and a body whose leaf case answered `1n`, or the
value the leaf carries, or a count of the leaf nodes, is caught only here.

`internal_count_node` is definitional too, and it is the step. It says a node
contributes exactly one of its own in addition to both subtrees: a body that
descended one side only, or that added `2n` for the node, or that dropped the
node's own contribution, leaves the two sides unconvertible.

`internal_count_inner` is the law with content, and the one that observes the
tree through something other than the recursion. `P.inner(t)` lists the keys of
the interior nodes, root first, one entry per interior node -- a leaf
contributes no entry, and a node's key comes in front of the two subtrees'
entries, in that order. The law says the count is how many entries that list
has. The tree is a variable, so `P.inner` and `P.len` do not reduce and this one
is the induction; it is also the law that separates a body that counted the
leaves from one that counted the interior nodes, since the two agree only on
trees that are all of one kind.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.internal_count_leaf(v)`, `def L.internal_count_node(l, key, r)` and
`def L.internal_count_inner(t)`. The list lemma the last proof needs goes under
the reserved `Policy.` namespace, which the gate ignores, and it may call the
prelude but never a law.
