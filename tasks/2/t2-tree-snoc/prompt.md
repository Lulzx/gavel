Implement `snoc_tree`, then prove the three laws in `LAWS.bend`.

The prelude's `P.Tree` is either `P.Leaf{v}`, a leaf carrying a `Nat`, or
`P.Node{l, r}`, a node with two subtrees. The right spine of a tree is the path
from the root following right children down to a leaf.

`snoc_tree(t, v)` is `t` with a new leaf `P.Leaf{v}` added at the rightmost
position: the leaf at the end of the right spine becomes the left child of a new
node whose right child is `P.Leaf{v}`. Nothing else changes, and the new leaf is
not placed above the existing tree.

    snoc_tree(P.Leaf{1n}, 5n) == P.Node{P.Leaf{1n}, P.Leaf{5n}}
    snoc_tree(P.Node{P.Leaf{1n}, P.Leaf{2n}}, 5n) == P.Node{P.Leaf{1n}, P.Node{P.Leaf{2n}, P.Leaf{5n}}}

The laws use three prelude names. `P.leftmost(t)` and `P.rightmost(t)` are the
values at the leftmost and rightmost leaves of `t`. `P.right_spine(t)` is the
number of nodes on the right spine of `t`, counting the leaf at the end, so a
leaf has `1n`.

- `snoc_tree_rightmost`: the rightmost value of `snoc_tree(t, v)` is `v`.
- `snoc_tree_leftmost`: the leftmost value of `snoc_tree(t, v)` is the leftmost
  value of `t`.
- `snoc_tree_right_spine`: the right spine of `snoc_tree(t, v)` has `1n` more
  nodes than the right spine of `t`, written `1n + P.right_spine(t)`.
