Implement `rightmost_value`, then prove the three laws in `LAWS.bend`.

`rightmost_value(t)` is the value carried by the rightmost leaf of the tree `t`,
the leaf reached by going into the right subtree at every node. No node key and
nothing in a left subtree is part of the answer.

The tree type is `P.Tree`, with constructors `P.Leaf{value}` and
`P.Node{l, key, r}`.

    rightmost_value(P.Leaf{4n}) == 4n
    rightmost_value(P.Node{P.Leaf{1n}, 2n, P.Leaf{3n}}) == 3n
    rightmost_value(P.Node{P.Leaf{1n}, 2n, P.Node{P.Leaf{3n}, 4n, P.Leaf{5n}}}) == 5n

The laws use `P.leftmost(t)`, the value carried by the leftmost leaf of `t`, and
`P.mirror(t)`, `t` with the two subtrees swapped at every node (keys stay with
their nodes).

- `rightmost_value_leaf`: a leaf `P.Leaf{v}` gives `v`.
- `rightmost_value_node`: `rightmost_value(P.Node{l, key, r})` is
  `rightmost_value(r)`.
- `rightmost_value_mirror`: `rightmost_value(P.mirror(t))` is `P.leftmost(t)`.
