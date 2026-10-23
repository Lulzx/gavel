Implement `path_sum`, then prove the five laws in `LAWS.bend`.

`path_sum(t)` is the sum, over every leaf of the tree `t`, of the values on the
path from the root down to that leaf: the leaf's own value plus the key of every
node above it. A key therefore counts once for each leaf beneath it.

    path_sum(P.Leaf{4n}) == 4n
    path_sum(P.Node{P.Leaf{1n}, 2n, P.Leaf{3n}}) == 8n
    path_sum(P.Node{P.Node{P.Leaf{1n}, 2n, P.Leaf{3n}}, 5n, P.Leaf{4n}}) == 27n

The tree type is `P.Tree`, with constructors `P.Leaf{value}` and
`P.Node{l, key, r}`. The laws use `P.leaves(t)`, the number of leaves of `t`,
and `P.zeroed(t)`, `t` with every leaf value and every node key set to `0n` and
the shape unchanged.

- `path_sum_leaf`: a leaf `P.Leaf{v}` gives `v`.
- `path_sum_node`: `path_sum(P.Node{l, key, r})` is `path_sum(l)` plus
  `path_sum(r)` plus `key` times `P.leaves(l)` plus `P.leaves(r)`.
- `path_sum_three`: `path_sum(P.Node{P.Leaf{1n}, 2n, P.Leaf{3n}})` is `8n`.
- `path_sum_deep`: `path_sum(P.Node{P.Node{P.Leaf{1n}, 2n, P.Leaf{3n}}, 5n, P.Leaf{4n}})`
  is `27n`.
- `path_sum_zeroed`: `path_sum(P.zeroed(t))` is `0n`.
