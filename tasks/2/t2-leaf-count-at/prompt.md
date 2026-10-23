Implement `leaf_count_at`, then prove the five laws in `LAWS.bend`.

The prelude's tree `P.Tree` is either `P.Leaf{v}`, a leaf carrying a value, or
`P.Node{l, key, r}`, an interior node with a key between two subtrees.
`leaf_count_at(t, k)` is the number of leaves of `t` at depth `k`, where the
root is at depth `0n`. It is `0n` if there is no leaf at that depth. A leaf
counts once whatever its value, an interior node is never a leaf, and keys are
not read.

    leaf_count_at(P.Leaf{9n}, 0n) == 1n
    leaf_count_at(P.Leaf{9n}, 2n) == 0n
    leaf_count_at(P.Node{P.Node{P.Leaf{1n}, 5n, P.Leaf{2n}}, 6n, P.Leaf{3n}}, 1n) == 1n
    leaf_count_at(P.Node{P.Node{P.Leaf{1n}, 5n, P.Leaf{2n}}, 6n, P.Leaf{3n}}, 2n) == 2n

The laws use these prelude names. `P.is_leaf(t)` is `True{}` when `t` is a
leaf. `P.at_if(b, x, y)` is `x` when `b` is `True{}` and `y` otherwise.
`P.mirror(t)` is `t` with the two subtrees swapped at every node.

- `leaf_count_at_leaf`: `leaf_count_at(P.Leaf{v}, 0n)` is `1n`.
- `leaf_count_at_leaf_deep`: `leaf_count_at(P.Leaf{v}, 1n + k)` is `0n`.
- `leaf_count_at_node_step`: `leaf_count_at(P.Node{l, key, r}, 1n + k)` is
  `leaf_count_at(l, k) + leaf_count_at(r, k)`.
- `leaf_count_at_root`: `leaf_count_at(t, 0n)` is `1n` if `P.is_leaf(t)` and
  `0n` otherwise, written with `P.at_if`.
- `leaf_count_at_mirror`: `leaf_count_at(P.mirror(t), k)` is `leaf_count_at(t, k)`.
