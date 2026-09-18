import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the empty list holds no `1n`. It is definitional, and it is the weak
# half: the constant body `False{}` satisfies it.
law has_one_nil:
  {S.has_one(Nil{}) == False{} : Bool}

# LAW: adding one element on the right ors in that element's test for `1n`.
# `append` matches on its first argument, so with a variable `xs` the goal
# does not reduce on its own: this one is inductive in `xs`, and it is the law
# that pins `has_one`. Alone it is satisfied by the constant body `True{}`,
# because `or` absorbs `True{}` on either side; the base law is what rules
# that body out. The constant body `False{}` fails it: the right-hand side is
# then `is_one_b(x)`, which is stuck on a variable `x`.
law has_one_snoc:
  for xs: List<Nat>
  for x: Nat
  {S.has_one(P.append(xs, x <> Nil{})) == Bool.or(S.has_one(xs), P.is_one_b(x)) : Bool}
