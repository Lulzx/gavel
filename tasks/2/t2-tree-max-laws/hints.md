The reference matches on the tree: `P.Leaf{v}` gives `v`, and `P.Node{l, r}`
gives `P.max(tree_max(l), tree_max(r))`.

`tree_max_leaf` and `tree_max_node` close by `{==}`.

`tree_max_flatten` is an induction on `t` (with `t` reusable). `P.max` matches
on its first argument and then its second, so on variables nothing reduces and
three `Policy.` lemmas are needed:

- `max_zero`: `{x == P.max(x, 0n) : Nat}`, a match on `x`, both cases `{==}`.
- `max_assoc`: `{P.max(P.max(a, b), c) == P.max(a, P.max(b, c)) : Nat}`, a match
  on `a`, then `b`, then `c` (with `b` and `c` reusable), using the hypothesis
  at the predecessors in the all-successor case under `1n +`.
- `max_all_append`: `{P.max(P.max_all(xs), P.max_all(ys)) == P.max_all(P.append(xs, ys)) : Nat}`,
  an induction on `xs`, using the hypothesis and then `max_assoc`.

Leaf case: `P.max_all` of a one-element list is `P.max(v, 0n)`, so rewrite
with `max_zero(v)`. Node case: rewrite the right side with
`max_all_append(P.flatten(l), P.flatten(r))`, then with the hypotheses at `l`
and at `r`, one after another, then `{==}`.
