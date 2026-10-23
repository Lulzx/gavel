Implement `tree_fold`, then prove the three laws in `LAWS.bend`.

The prelude's `P.Tree` is either `P.Leaf{v}`, a leaf carrying a `Nat`, or
`P.Node{l, r}`, a node with two subtrees.

`tree_fold(t, acc)` is the leaf values of `t`, read left to right, followed by
the list `acc`. A leaf gives its value in front of `acc`.

    tree_fold(P.Leaf{4n}, [9n]) == [4n, 9n]
    tree_fold(P.Node{P.Leaf{1n}, P.Leaf{2n}}, [9n]) == [1n, 2n, 9n]
    tree_fold(P.Node{P.Leaf{1n}, P.Leaf{2n}}, Nil{}) == [1n, 2n]

The laws use the prelude's `P.flatten(t)`, the leaf values of `t` read left to
right, and `P.append(xs, ys)`, the list `xs` followed by the list `ys`.

- `tree_fold_leaf`: folding `P.Leaf{v}` onto `acc` gives `v <> acc`.
- `tree_fold_node`: folding `P.Node{l, r}` onto `acc` is folding `l` onto the
  result of folding `r` onto `acc`.
- `tree_fold_flatten`: folding `t` onto `acc` is `P.flatten(t)` followed by
  `acc`.
