import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: every element of the empty list is a multiple of five, vacuously.
# It is definitional, and it is the weak half: the constant body `True{}`
# satisfies it.
law all_mult5_nil:
  {S.all_mult5(Nil{}) == True{} : Bool}

# LAW: adding one element on the right ands in that element's test.
# `append` matches on its first argument, so with a variable `xs` the goal
# does not reduce on its own: this one is inductive in `xs`, and it is the law
# that pins `all_mult5`. Alone it is satisfied by the constant body `False{}`,
# because `and` absorbs `False{}` on either side; the base
# law is what rules that body out. The constant body `False{}` fails it:
# the right-hand side is then `is_mult5_b(x)`, which is stuck on a variable `x`.
law all_mult5_snoc:
  for xs: List<Nat>
  for x: Nat
  {S.all_mult5(P.append(xs, x <> Nil{})) == Bool.and(S.all_mult5(xs), P.is_mult5_b(x)) : Bool}
