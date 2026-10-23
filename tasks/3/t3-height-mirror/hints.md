The reference matches on the tree: `P.Leaf{}` answers `0n` and `P.Node{l, r}`
answers `1n + P.max(height(l), height(r))`.

- `height_leaf` and `height_node`: both sides compute, so `{==}`.
- `height_mirror`: induction on `t` (bound `+t`, so the subtrees can be used
  twice). `P.Leaf{}` is `{==}`. In the node case the goal reduces to

      1n + P.max(S.height(P.mirror(r)), S.height(P.mirror(l))) == 1n + P.max(S.height(l), S.height(r))

  Rewrite `S.height(P.mirror(r))` with `L.height_mirror(r)` and then
  `S.height(P.mirror(l))` with `L.height_mirror(l)` (both flipped with
  `Equal.sym`). What remains is `P.max(S.height(r), S.height(l))` against
  `P.max(S.height(l), S.height(r))`. `P.max` steps on its first argument and
  then its second, so it is stuck on variables: prove a `Policy.` lemma
  `P.max(a, b) == P.max(b, a)` (with `+b`) by induction on `a` with a match on
  `b` in each case; all four cases close by `{==}` except successor/successor,
  which rewrites with the hypothesis at `(p, q)` under `1n + _`. Rewrite with
  `max_comm(S.height(r), S.height(l))` on the right side and close by `{==}`.
