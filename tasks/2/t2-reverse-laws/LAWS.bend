import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: reversing a one-element list leaves it alone. It is definitional, and it
# is the weak half: the identity body, which hands back the list it was given,
# satisfies it.
law reverse_single:
  for h: Nat
  {S.reverse(h <> Nil{}) == h <> Nil{} : List<Nat>}

# LAW: reversing `xs <> [x]` is `x` in front of the reverse of `xs`: the last
# element comes first. It is inductive in `xs`, and it is the law that pins
# `reverse`: the identity body fails it as soon as `xs` is non-empty, because
# `xs <> [x]` and `[x] <> xs` are different lists there. The law above is the
# closed-value anchor beside it -- the identity body proves that one, which is
# what makes it the weak half rather than a second way of pinning `reverse`.
law reverse_snoc:
  for xs: List<Nat>
  for x: Nat
  {S.reverse(P.snoc(xs, x)) == x <> S.reverse(xs) : List<Nat>}
