Implement `same_shape`, then prove the six laws in `LAWS.bend`.

`same_shape(t1, t2)` says whether the trees `t1` and `t2` are built the same way,
ignoring every value they carry. Two leaves have the same shape, a leaf and a node
do not, and two nodes have the same shape exactly when their left subtrees have the
same shape and their right subtrees do too. It answers a `Bool`.

The tree type is `P.Tree`, with constructors `P.Leaf{value}` and
`P.Node{l, key, r}`.

    same_shape(P.Node{P.Leaf{1n}, 2n, P.Leaf{3n}}, P.Node{P.Leaf{9n}, 8n, P.Leaf{7n}}) == True{}
    same_shape(P.Node{P.Leaf{1n}, 2n, P.Leaf{3n}}, P.Leaf{1n}) == False{}
    same_shape(P.Leaf{1n}, P.Leaf{5n}) == True{}

The laws use `P.relabel(t)`, `t` with every leaf value and every node key
increased by `1n`, the shape unchanged.

- `same_shape_leaf_leaf`: two leaves, whatever they carry, give `True{}`.
- `same_shape_leaf_node`: a leaf and a node give `False{}`.
- `same_shape_node_leaf`: a node and a leaf give `False{}`.
- `same_shape_node_node`: two nodes give `Bool.and` of the comparison of the left
  subtrees and the comparison of the right subtrees; the keys are not looked at.
- `same_shape_relabel`: `same_shape(t, P.relabel(t))` is `True{}`.
- `same_shape_self`: `same_shape(t, t)` is `True{}`.
