The reference matches on the tree: `P.Leaf{v}` answers `v`, and
`P.Node{l, key, r}` answers `rightmost_value(r)`.

- `rightmost_value_leaf` and `rightmost_value_node` close by `{==}`.
- `rightmost_value_mirror`: induction on `t`. The leaf case is `{==}`. In the
  node case `P.mirror` puts `P.mirror(l)` on the right, so the walk steps onto
  it, and `P.leftmost` steps onto `l`: the goal is exactly the hypothesis at
  `l`. The case body is just `L.rightmost_value_mirror(l)`, with no rewrite.
