import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: no element of the empty list is a multiple of five, vacuously.
# It is definitional, and it is the weak half: the constant body `False{}`
# satisfies it.
law has_mult5_nil:
  {S.has_mult5(Nil{}) == False{} : Bool}

# LAW: adding one element on the right ors in that element's test.
# `append` matches on its first argument, so with a variable `xs` the goal
# does not reduce on its own: this one is inductive in `xs`, and it is the law
# that pins `has_mult5`. Alone it is satisfied by the constant body `True{}`,
# because `or` absorbs `True{}` on either side; the base
# law is what rules that body out. The constant body `True{}` fails it:
# the right-hand side is then `is_mult5_b(x)`, which is stuck on a variable `x`.
law has_mult5_snoc:
  for xs: List<Nat>
  for x: Nat
  {S.has_mult5(P.append(xs, x <> Nil{})) == Bool.or(S.has_mult5(xs), P.is_mult5_b(x)) : Bool}
