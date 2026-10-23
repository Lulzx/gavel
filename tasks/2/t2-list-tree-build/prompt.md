Implement `build`, then prove the five laws in `LAWS.bend`.

The prelude's tree `P.Tree` is either `P.Leaf{v}`, a leaf carrying a number, or
`P.Node{l, r}`, a node with a left and a right subtree. `build(bs)` turns a
list into a tree with one leaf per element, in list order down the right-hand
side: each element becomes a leaf that is the left child of a node, and the
right child of that node holds the rest of the list. The empty list becomes the
sentinel leaf `P.Leaf{0n}`, which therefore ends every right spine.

    build(Nil{})    == P.Leaf{0n}
    build([5n])     == P.Node{P.Leaf{5n}, P.Leaf{0n}}
    build([1n, 2n]) == P.Node{P.Leaf{1n}, P.Node{P.Leaf{2n}, P.Leaf{0n}}}

The laws use these prelude names. `P.len(bs)` is the number of elements of a
list. `P.leaves(t)` is the number of leaves of `t`. `P.right_spine(t)` is the
number of nodes on the right spine of `t`: one for the leaf it ends at and one
for each `P.Node` passed through. `P.rightmost(t)` is the value at the leaf the
right spine ends at. `P.last_or_zero(bs)` is the last element of `bs`, or `0n`
for the empty list.

- `build_nil`: `build(Nil{})` is `P.Leaf{0n}`.
- `build_cons`: `build(h <> t)` is a `P.Node` whose left child is `P.Leaf{h}`
  and whose right child is `build(t)`.
- `build_leaves`: `P.leaves(build(bs))` is `1n + P.len(bs)`.
- `build_right_spine`: `P.right_spine(build(bs))` is `1n + P.len(bs)`.
- `build_last`: `P.rightmost(build(bs))` is `P.last_or_zero(bs)`.
