The reference matches on the tree. `P.Leaf{v}` gives `k`, and
`P.Node{l, key, r}` gives `k + tree_depth_sum(l, 1n + k) + tree_depth_sum(r, 1n + k)`.
`k` is used three times, so it is a `+k` parameter.

All three laws close by `{==}`: the tree is a constructor in each, so the match
steps, and the right side is the same term.
