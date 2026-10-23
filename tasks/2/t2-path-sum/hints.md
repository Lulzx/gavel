The reference matches on the tree: `P.Leaf{v}` answers `v`, and
`P.Node{+l, key, +r}` answers
`Nat.add(Nat.add(path_sum(l), path_sum(r)), Nat.mul(key, Nat.add(P.leaves(l), P.leaves(r))))`.
The subtrees are used twice (recursion and `P.leaves`), so they are bound `+`.

- `path_sum_leaf`, `path_sum_node`, `path_sum_three` and `path_sum_deep` close
  by `{==}`.
- `path_sum_zeroed`: induction on `t`. The leaf case is `{==}`. In the node case
  `P.zeroed` gives a `0n` key, so the key term is `Nat.mul(0n, ...)`, which is
  `0n`, leaving the two subtree sums. Rewrite each with its hypothesis, flipped
  with `Equal.sym` because each says `path_sum(P.zeroed(l)) == 0n`:

      %Equal.sym(Nat, S.path_sum(P.zeroed(l)), 0n, L.path_sum_zeroed(l)) : {Nat.add(Nat.add(_, S.path_sum(P.zeroed(r))), 0n) == 0n : Nat}

  then the same for `r` (with `0n` where `l`'s answer was), then `{==}`.
