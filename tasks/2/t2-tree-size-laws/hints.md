The reference matches on the tree: `P.Leaf{v}` gives `1n`, and
`P.Node{l, key, r}` gives `1n + tree_size(l) + tree_size(r)`.

`tree_size_leaf` and `tree_size_node` close by `{==}`.

`tree_size_nodes` is an induction on `t`, matching `P.Leaf{v}` (closes by
`{==}`) and `P.Node{+l, key, +r}`. `P.nodes` of a node is
`key <> P.append(P.nodes(l), P.nodes(r))`, so `P.len` steps to
`1n + P.len(P.append(...))` and the proof needs a `Policy.` lemma, by induction
on the first list: `{P.len(xs) + P.len(ys) == P.len(P.append(xs, ys)) : Nat}`.
Then three rewrites, each replacing a piece of the right side:

    %Policy.len_append(P.nodes(l), P.nodes(r)) : {S.tree_size(P.Node{l, key, r}) == 1n + _ : Nat}
    %L.tree_size_nodes(l) : {1n + S.tree_size(l) + S.tree_size(r) == 1n + (_ + P.len(P.nodes(r))) : Nat}
    %L.tree_size_nodes(r) : {1n + S.tree_size(l) + S.tree_size(r) == 1n + (S.tree_size(l) + _) : Nat}
    {==}
