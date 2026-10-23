The reference matches on the tree, then on the depth. `P.Leaf{v}` gives `v` at
`0n` and `0n` at `1n+kp`. `P.Node{l, key, r}` gives `key` at `0n` and
`tree_level_sum(l, kp) + tree_level_sum(r, kp)` at `1n++kp` (`kp` is used twice,
so it is bound reusable).

The first three laws close by `{==}`: the tree and depth are constructors.

`tree_level_sum_root` has a variable tree, so match on `t`: both the
`P.Leaf{v}` case and the `P.Node{l, key, r}` case close by `{==}`.
