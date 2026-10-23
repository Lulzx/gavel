The reference matches on the tree: `P.Leaf{w}` gives `P.Node{P.Leaf{v}, P.Leaf{w}}`,
and `P.Node{l, r}` gives `P.Node{tree_insert(l, v), r}`, so the insertion goes
down the left side only.

`tree_insert_leaf` and `tree_insert_node` close by `{==}`.

`tree_insert_flatten` is an induction on `t` (with `t` reusable). The
`P.Leaf{w}` case closes by `{==}`. In the `P.Node{+l, +r}` case, `P.flatten`
steps to `P.append(P.flatten(tree_insert(l, v)), P.flatten(r))`. Flip the
hypothesis at `l` with `Equal.sym` and use it to replace
`P.flatten(tree_insert(l, v))` by `v <> P.flatten(l)`; then `P.append` steps on
the cons and both sides agree, so close with `{==}`. No list lemma is needed.

    %Equal.sym(List<&2, Nat>, P.flatten(S.tree_insert(l, v)), v <> P.flatten(l), L.tree_insert_flatten(l, v)) : {P.append(_, P.flatten(r)) == v <> P.append(P.flatten(l), P.flatten(r)) : List<&2, Nat>}
    {==}
