Implement `tree_insert`, then prove the three laws in `LAWS.bend`.

The prelude's `P.Tree` is either `P.Leaf{v}`, a leaf carrying a `Nat`, or
`P.Node{l, r}`, a node with two subtrees.

`tree_insert(t, v)` is `t` with a new leaf holding `v` added immediately to the
left of the leftmost leaf of `t`. No leaf is lost: the old leftmost leaf is
still there, now as the right neighbour of the new one, in a node together with
it.

    tree_insert(P.Leaf{1n}, 5n) == P.Node{P.Leaf{5n}, P.Leaf{1n}}
    tree_insert(P.Node{P.Leaf{1n}, P.Leaf{2n}}, 5n) == P.Node{P.Node{P.Leaf{5n}, P.Leaf{1n}}, P.Leaf{2n}}

The laws use the prelude's `P.flatten(t)`, the leaf values of `t` read left to
right, and `P.append(xs, ys)`, the list `xs` followed by the list `ys`.

- `tree_insert_leaf`: inserting `v` into `P.Leaf{w}` gives
  `P.Node{P.Leaf{v}, P.Leaf{w}}`.
- `tree_insert_node`: inserting `v` into `P.Node{l, r}` gives a node whose left
  subtree is `l` with `v` inserted and whose right subtree is `r` unchanged.
- `tree_insert_flatten`: the leaf values of `t` with `v` inserted are `v`
  followed by the leaf values of `t`.
