Implement `internal_count`, then prove the three laws in `LAWS.bend`.

The prelude's tree `P.Tree` is either `P.Leaf{v}`, a leaf carrying a value, or
`P.Node{l, key, r}`, an interior node with a key between two subtrees.
`internal_count(t)` is the number of interior nodes (`P.Node`s) in `t`. Leaves
count for nothing, and neither the values nor the keys matter.

    internal_count(P.Leaf{4n}) == 0n
    internal_count(P.Node{P.Leaf{1n}, 5n, P.Leaf{2n}}) == 1n
    internal_count(P.Node{P.Leaf{1n}, 5n, P.Node{P.Leaf{2n}, 6n, P.Leaf{3n}}}) == 2n

The laws use these prelude names. `P.inner(t)` is the list of the keys of the
interior nodes of `t`, one entry per node. `P.len(xs)` is the number of elements
of `xs`. `P.append(xs, ys)` is `xs` followed by `ys`.

- `internal_count_leaf`: `internal_count(P.Leaf{v})` is `0n`.
- `internal_count_node`: `internal_count(P.Node{l, key, r})` is `1n` plus
  `internal_count(l)` plus `internal_count(r)`.
- `internal_count_inner`: `internal_count(t)` is `P.len(P.inner(t))`.
