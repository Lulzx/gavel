The reference matches on `xs`, then on `ys`: `Nil{}` on either answers `0n`;
two cons cells `h <> t` and `k <> u` answer
`P.pick(P.eq(h, k), 1n, 0n) + count_matches(t, u)`.

- `count_matches_nil`, `count_matches_nil_right`, `count_matches_cons`: close by
  `{==}` (the matches step on the constructors given).
- `count_matches_self`: induction on `xs`; `Nil{}` is `{==}`. In the cons case
  `P.eq(h, h)` is stuck on a variable, so a `Policy.` lemma `eq_refl(x)`:
  `P.eq(x, x) == True{}` is needed, itself an induction on `x` (the step
  rewrites with `Equal.sym` of the hypothesis at the predecessor, goal
  `{_ == True{} : Bool}`). Then in the law, two rewrites, each hypothesis
  flipped with `Equal.sym`:

      %Equal.sym(Nat, S.count_matches(t, t), P.len(t), L.count_matches_self(t)) : {P.pick(P.eq(h, h), 1n, 0n) + _ == 1n + P.len(t) : Nat}
      %Equal.sym(Bool, P.eq(h, h), True{}, Policy.eq_refl(h)) : {P.pick(_, 1n, 0n) + P.len(t) == 1n + P.len(t) : Nat}
      {==}
