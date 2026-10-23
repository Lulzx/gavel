The reference matches on both trees at once, with four cases: leaf/leaf answers
`True{}`, leaf/node and node/leaf answer `False{}`, and node/node answers
`Bool.and(same_shape(l1, l2), same_shape(r1, r2))`. Bound values are never read.

- The first four laws each pick one case of the match and close by `{==}`.
- `same_shape_relabel` and `same_shape_self` are inductions on `t`. The leaf case
  is `{==}`. In the node case, bind the subtrees `+l`, `+r` (each is used by a
  hypothesis and in the goal), and both sides reduce to the `Bool.and` of the two
  subtree comparisons. Rewrite each comparison to `True{}` with its hypothesis,
  flipped by `Equal.sym`, one at a time, then `{==}`:

      %Equal.sym(Bool, S.same_shape(l, l), True{}, L.same_shape_self(l)) : {Bool.and(_, S.same_shape(r, r)) == True{} : Bool}
      %Equal.sym(Bool, S.same_shape(r, r), True{}, L.same_shape_self(r)) : {Bool.and(True{}, _) == True{} : Bool}

  The relabel proof is the same with `P.relabel(l)` and `P.relabel(r)` as the
  second arguments.
