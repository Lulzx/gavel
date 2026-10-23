Implement `tree_max`, then prove the three laws in `LAWS.bend`.

The prelude's `P.Tree` is either `P.Leaf{v}`, a leaf carrying a `Nat`, or
`P.Node{l, r}`, a node with two subtrees. Only the leaves carry numbers.

`tree_max(t)` is the largest number carried by a leaf of `t`.

    tree_max(P.Leaf{4n}) == 4n
    tree_max(P.Node{P.Leaf{3n}, P.Leaf{8n}}) == 8n
    tree_max(P.Node{P.Node{P.Leaf{9n}, P.Leaf{2n}}, P.Leaf{5n}}) == 9n

The laws use four prelude names. `P.max(a, b)` is the larger of `a` and `b`.
`P.flatten(t)` is the leaf values of `t` read left to right. `P.append(xs, ys)`
is the list `xs` followed by the list `ys`. `P.max_all(xs)` is the largest
element of `xs`, or `0n` when `xs` is empty.

- `tree_max_leaf`: the maximum of `P.Leaf{v}` is `v`.
- `tree_max_node`: the maximum of `P.Node{l, r}` is the larger of the maximum of
  `l` and the maximum of `r`.
- `tree_max_flatten`: the maximum of `t` is `P.max_all(P.flatten(t))`.
