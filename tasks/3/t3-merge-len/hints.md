`merge` matches `xs` then `ys` and hands two conses to
`merge_go(tx, hx, ty, hy, P.le(hx, hy))`. Since a `match` cannot scrutinise
`P.le(...)`, the decision is a parameter, and since nothing can be matched
after the last parameter, `merge_go` matches `tx`, then `ty`, then `k` last in
every branch (eight leaves). A recursive call passes the next decision as
`P.le` of the next two heads, e.g. `hx <> merge_go(tx2, hx2, ty, hy, P.le(hx2, hy))`
in the `(cons, _, True)` leaves; the shrinking tail must be the argument that
differs first. When a tail is empty the leaf writes the remaining list out
literally. All four of `tx`, `hx`, `ty`, `hy` are `+`.

- `merge_nil_l`, `merge_go_true`, `merge_go_false`: `{==}`.
- `merge_nil_r`: match on `xs`; both cases `{==}`.
- `merge_len`: generalize over both tails and the decision in a lemma
  `Policy.merge_go_len(tx, hx, ty, hy, k)`:
  `P.len(S.merge_go(tx, hx, ty, hy, k)) == (1n + P.len(tx)) + (1n + P.len(ty))`,
  proved by the same three-level match as the body. Each recursive leaf
  rewrites with the lemma at the recursive call's arguments (flipped with
  `Equal.sym`), then closes; the arithmetic uses `Policy.` facts
  `a + 1n == 1n + a` and `b + (1n + p) == 1n + (b + p)` (each by induction).
  The law itself matches `xs` then `ys`: `Nil{}` is `{==}`, `(cons, Nil)` needs
  `a == a + 0n`, and `(cons, cons)` is one rewrite with the lemma.
- `merge_le_head` / `merge_gt_head`: match `tx` and `ty` so `merge` on both
  sides reduces to `merge_go`. In each of the four cases spend the premise with
  `Equal.cong` over the decision argument:

      %Equal.cong(Bool, List<&2, Nat>, k => S.merge_go(Nil{}, hx, Nil{}, hy, k), P.le(hx, hy), True{}, e)
          : {S.merge_go(Nil{}, hx, Nil{}, hy, P.le(hx, hy)) == _ : List<&2, Nat>}
      {==}

  (`False{}` for `merge_gt_head`). A bare `{==}` fails: the decision is stuck.
