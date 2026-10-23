The reference matches on the list, then on its tail: `Nil{}` answers `Nil{}`,
`h <> Nil{}` answers `h <> Nil{}`, and `h <> (h2 <> t2)` answers
`P.same_put(h, dedup(h2 <> t2), P.same(h, h2))`. The decision goes through
`P.same_put` because a match cannot scrutinise `P.same(h, h2)`. `h` and `h2`
are used twice, so bind `+h` and `+h2`, and rebuild `h2 <> t2` for the recursive
call.

- `dedup_nil`, `dedup_single`, `dedup_cons`: close by `{==}`.
- `dedup_same`: the goal leaves `P.same_put(a, dedup(a <> t), P.same(a, a))`,
  and `P.same(a, a)` is stuck on a variable. A `Policy.` lemma `same_refl(a)`:
  `True{} == P.same(a, a)`, an induction on `a` (the step rewrites with the
  hypothesis, goal `{True{} == _ : Bool}`). Then:

      %Policy.same_refl(a) : {P.same_put(a, S.dedup(a <> t), _) == S.dedup(a <> t) : List<&2, Nat>}
      {==}
