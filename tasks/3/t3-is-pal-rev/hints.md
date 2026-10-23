The reference is `P.eq_list(xs, P.rev(xs))`, with `xs` declared `+`.

- `is_pal_nil` and `is_pal_two_distinct`: closed terms, so `{==}`.
- `is_pal_single`: the goal unfolds to `Bool.and(P.eq_nat(h, h), True{}) == True{}`,
  stuck on `h`. Rewrite with a `Policy.` lemma `P.eq_nat(a, a) == True{}`
  (induction on `a`), flipped, then `{==}`.
- `is_pal_rev`: the goal unfolds to
  `P.eq_list(P.rev(xs), P.rev(P.rev(xs))) == P.eq_list(xs, P.rev(xs))`. Two
  rewrites: `P.rev(P.rev(xs))` to `xs` with a `Policy.` `rev_rev`, then the
  whole left side with list-equality symmetry at `(P.rev(xs), xs)` (both
  flipped with `Equal.sym`); then `{==}`.

The `Policy.` lemmas (`rev_rev` is a law of another task, so it is reproved
here):

- `P.eq_nat(a, b) == P.eq_nat(b, a)`: induction on `a` with a match on `b`.
- `P.eq_list(xs, ys) == P.eq_list(ys, xs)`: match on both lists; the cons/cons
  case rewrites the head comparison with the `eq_nat` symmetry and the tails
  with the hypothesis at `(t, t2)`, each on the right side of the goal.
- `P.rev(P.snoc(xs, y)) == y <> P.rev(xs)`: induction on `xs`; the cons case
  rewrites `P.rev(P.snoc(t, y))` with the hypothesis (flipped).
- `P.rev(P.rev(xs)) == xs` (with `+xs`): induction on `xs`; the cons case
  rewrites `P.rev(P.snoc(P.rev(t), h))` with `rev_snoc(P.rev(t), h)`, then
  `P.rev(P.rev(t))` with the hypothesis (both flipped), then `{==}`.
