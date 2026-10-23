The reference matches on the tree: `P.Leaf{v}` gives `v <> acc`, and
`P.Node{l, r}` gives `tree_fold(l, tree_fold(r, acc))`: the right subtree is
folded first, and the left is folded onto the result.

`tree_fold_leaf` and `tree_fold_node` close by `{==}`.

`tree_fold_flatten` is an induction on `t` (with `t` and `acc` reusable). The
leaf case closes by `{==}`. In the node case both subtree hypotheses are used,
and the result needs `P.append` to be associative, a `Policy.` lemma proved by
induction on the first list (its cons step flips the hypothesis with
`Equal.sym`): `{P.append(P.append(xs, ys), zs) == P.append(xs, P.append(ys, zs)) : List<&2, Nat>}`.

In the node case, three rewrites, each flipping a hypothesis with `Equal.sym`
or using the lemma:

- the hypothesis at `(r, acc)` rewrites `tree_fold(r, acc)` into
  `P.append(P.flatten(r), acc)`;
- the hypothesis at `(l, P.append(P.flatten(r), acc))` rewrites the outer fold
  into `P.append(P.flatten(l), P.append(P.flatten(r), acc))`;
- `append_assoc(P.flatten(l), P.flatten(r), acc)` regroups that into
  `P.append(P.append(P.flatten(l), P.flatten(r)), acc)`.

Then `{==}`.
