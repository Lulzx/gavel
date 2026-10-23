The reference matches on the tree: `P.Leaf{v}` gives `1n`, and `P.Node{l, r}`
gives `tree_leaf_count(l) + tree_leaf_count(r)`.

`tree_leaf_count_leaf` and `tree_leaf_count_node` close by `{==}`.

`tree_leaf_count_flatten` is an induction on `t` (with `t` reusable). The leaf
case closes by `{==}`. In the node case, `P.flatten` gives
`P.append(P.flatten(l), P.flatten(r))`, so the proof needs a `Policy.` lemma,
by induction on the first list:
`{P.len(xs) + P.len(ys) == P.len(P.append(xs, ys)) : Nat}`. Then three
rewrites, each replacing a piece of the right side:

    %Policy.len_append(P.flatten(l), P.flatten(r)) : {S.tree_leaf_count(l) + S.tree_leaf_count(r) == _ : Nat}
    %L.tree_leaf_count_flatten(l) : {S.tree_leaf_count(l) + S.tree_leaf_count(r) == _ + P.len(P.flatten(r)) : Nat}
    %L.tree_leaf_count_flatten(r) : {S.tree_leaf_count(l) + S.tree_leaf_count(r) == S.tree_leaf_count(l) + _ : Nat}
    {==}
