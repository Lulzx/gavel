Implement `tree_size`, then prove the three laws in `LAWS.bend`.

The prelude's `P.Tree` is either `P.Leaf{v}`, a leaf carrying a `Nat`, or
`P.Node{l, key, r}`, a node with a key and two subtrees.

`tree_size(t)` is the number of nodes of `t`, counting both leaves and
`P.Node`s. Keys and values are not counted or read.

    tree_size(P.Leaf{9n}) == 1n
    tree_size(P.Node{P.Leaf{1n}, 2n, P.Leaf{3n}}) == 3n
    tree_size(P.Node{P.Node{P.Leaf{1n}, 2n, P.Leaf{3n}}, 4n, P.Leaf{5n}}) == 5n

The laws use the prelude's `P.nodes(t)`, the list of values carried by the nodes
of `t`, with a node's key first and then the values of its left subtree and its
right subtree (a leaf contributes its value), and `P.len(xs)`, the number of
elements of `xs`.

- `tree_size_leaf`: a leaf has size `1n`.
- `tree_size_node`: the size of `P.Node{l, key, r}` is `1n` plus the size of `l`
  plus the size of `r`.
- `tree_size_nodes`: the size of `t` is the length of `P.nodes(t)`.
