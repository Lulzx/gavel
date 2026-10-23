Implement `count_at_depth`, then prove the four laws in `LAWS.bend`.

`count_at_depth(t, d)` is the number of nodes of the tree `t` at depth `d`, where
the root is at depth `0n`. It is `0n` when the tree is shallower than `d`. The
tree type is the prelude's `P.Tree`: `P.Tip{}` is the empty tree, which is not a
node and so holds nothing at any depth, and `P.Bin{l, key, r}` is one node with
subtrees `l` and `r`. The key is never read: this counts nodes, it does not add
keys.

    count_at_depth(P.Bin{P.Bin{P.Tip{}, 1n, P.Tip{}}, 2n, P.Bin{P.Tip{}, 3n, P.Tip{}}}, 0n) == 1n
    count_at_depth(P.Bin{P.Bin{P.Tip{}, 1n, P.Tip{}}, 2n, P.Bin{P.Tip{}, 3n, P.Tip{}}}, 1n) == 2n
    count_at_depth(P.Bin{P.Bin{P.Tip{}, 1n, P.Tip{}}, 2n, P.Bin{P.Tip{}, 3n, P.Tip{}}}, 2n) == 0n
    count_at_depth(P.Tip{}, 3n) == 0n

The prelude's `P.is_tip(t)` is `True{}` when `t` is `P.Tip{}` and `False{}`
otherwise. `P.at_if(b, x, y)` is `x` when `b` is `True{}` and `y` when it is
`False{}`.

- `count_at_depth_tip`: a tip has `0n` nodes at every depth `d`.
- `count_at_depth_zero`: at depth `0n` the count of any tree `t` is
  `P.at_if(P.is_tip(t), 0n, 1n)`: `0n` for a tip, `1n` for a bin.
- `count_at_depth_step`: for a bin `P.Bin{l, key, r}` at depth `1n + d`, the count
  is the count of `l` at depth `d` plus the count of `r` at depth `d`.
- `count_at_depth_three`: the three-node tree above has `2n` nodes at depth `1n`.
