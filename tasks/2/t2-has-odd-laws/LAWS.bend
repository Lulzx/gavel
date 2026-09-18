import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the empty list holds no odd number. It is definitional, and it is the
# weak half: the constant body `False{}` satisfies it.
law has_odd_nil:
  {S.has_odd(Nil{}) == False{} : Bool}

# LAW: adding one element on the right ors in that element's odd test.
# `append` matches on its first argument, so with a variable `xs` the goal
# does not reduce on its own: this one is inductive in `xs`, and it is the law
# that pins `has_odd`. Alone it is satisfied by the constant body `True{}`,
# because `or` absorbs `True{}` on either side; the base law is what rules
# that body out. The constant body `False{}` fails it: the right-hand side is
# then `is_odd_b(x)`, which is stuck on a variable `x`.
law has_odd_snoc:
  for xs: List<Nat>
  for x: Nat
  {S.has_odd(P.append(xs, x <> Nil{})) == Bool.or(S.has_odd(xs), P.is_odd_b(x)) : Bool}
