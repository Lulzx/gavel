Implement `mirror`, then prove the four laws in `LAWS.bend`.

`mirror(t)` is `t` with the two subtrees swapped at every node; the leaves keep
their values.

    mirror(P.Leaf{4n}) == P.Leaf{4n}
    mirror(P.Node{P.Leaf{1n}, P.Node{P.Leaf{2n}, P.Leaf{3n}}}) == P.Node{P.Node{P.Leaf{3n}, P.Leaf{2n}}, P.Leaf{1n}}

The tree is the prelude's `P.Tree`, with a number at each `P.Leaf{v}` and two
subtrees at each `P.Node{l, r}`. `P.leftmost(t)` and `P.rightmost(t)` are the
values at the leftmost and the rightmost leaf. `P.size(t)` is the sum of the
leaf values (a leaf `P.Leaf{v}` contributes `v`).

- `mirror_mirror`: mirroring twice gives back the tree.
- `mirror_leftmost`: the rightmost value of the mirror is the leftmost value of
  the tree.
- `mirror_rightmost`: the leftmost value of the mirror is the rightmost value of
  the tree.
- `mirror_size`: the mirror has the same `P.size` as the tree.
