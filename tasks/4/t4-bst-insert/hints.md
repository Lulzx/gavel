The reference `insert` answers the leaf on `P.Tip{}`, and on a node it is
`ins_at(P.Bin{l, key, r}, P.le(k, key), k)`, reassembling the node from `+`
pattern variables. `ins_at` matches the tree, then the decision `c`, and
recurses into the chosen subtree with `P.le(k, P.root_key(sub))` as the next
decision, so `insert` and `ins_at` never call each other. `count` is
`P.is_eq(key, x) + count(l, x) + count(r, x)`, `0n` at a tip.

- `insert_leaf`, `ins_at_tip`, `ins_at_left`, `ins_at_right`, `count_tip`: each
  goal has a closed constructor where the body matches, so `{==}`.
- `insert_le` / `insert_gt`: the goal reduces to `ins_at(..., P.le(y, x), y)`,
  stuck on the decision. Rewrite it with the premise, flipped:
  `%Equal.sym(Bool, P.le(y, x), True{}, e) : {S.ins_at(P.Bin{P.Tip{}, x, P.Tip{}}, _, y) == ... }`,
  then `{==}` (same with `False{}`).
- `insert_ordered`: match `t`; the tip is `{==}`; the node case calls a
  `Policy.ord_ins(t, c, k, e_c: {c == P.le(k, P.root_key(t))}, e_t: {P.ordered(t) == True{}})`
  proving `P.ordered(S.ins_at(t, c, k)) == True{}` with `e_c = {==}`. That is an
  induction on `t` then a match on `c`, built from small Bool lemmas:
  `and_l`/`and_r` (from `Bool.and(a, b) == True{}` get `a`/`b == True{}`, the
  `False` case of `and_r` by transporting along `False{} == True{}` with
  `Equal.cong`), `and_i` (build a conjunction), and `le_flip`
  (`P.le(a, b) == False{}` gives `P.le(b, a) == True{}`, induction). The bound
  facts come from two more inductions generalised over the bound `b`:
  `all_le_ins` (`all_le(t, b)` and `le(k, b)` give `all_le(ins_at(t, c, k), b)`)
  and its mirror `all_ge_ins`. In the left branch `le(k, key)` is `e_c` flipped;
  in the right it is `le_flip` of it.
- `insert_count`: match `t` and call `Policy.count_ins(t, c, k, x)`, stated over
  `ins_at`, by induction on `t` and a match on `c`. The tip case needs
  `a == a + 0n` twice. The left branch rewrites with the hypothesis, then
  reassociates with `a + (b + c) == (a + b) + c` and commutes
  `P.is_eq(k, x)` past `count(r, x)` with `a + b == b + a` (itself needing
  `a == a + 0n` and `b + (1n + p) == 1n + (b + p)`). The right branch needs only
  the hypothesis and one reassociation.
