Implement `flatten`, then prove the four laws in `LAWS.bend`.

`flatten(t)` is the list of the leaf values of `t`, read left to right.

    flatten(P.Leaf{4n}) == [4n]
    flatten(P.Node{P.Node{P.Leaf{1n}, P.Leaf{2n}}, P.Leaf{3n}}) == [1n, 2n, 3n]

The tree is the prelude's `P.Tree`, with a number at each `P.Leaf{v}` and two
subtrees at each `P.Node{l, r}`; the list type is `List<&2, Nat>`.
`P.append(xs, ys)` is `xs` followed by `ys`, `P.len(xs)` is the number of
elements, `P.rev(xs)` is `xs` reversed, `P.leaves(t)` is the number of leaves of
`t`, and `P.mirror(t)` is `t` with the two subtrees swapped at every node.

- `flatten_leaf`: a leaf flattens to the one-element list of its value.
- `flatten_node`: a node flattens to its left subtree's list followed by its
  right subtree's.
- `flatten_leaves`: the flattened list has as many elements as the tree has
  leaves.
- `flatten_mirror`: flattening the mirror of a tree gives the reverse of
  flattening the tree.
