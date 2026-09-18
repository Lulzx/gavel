import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: reversing a list that ends in one new element puts that element on the
# left. `append` matches on its first argument, so with a variable `xs` the goal
# does not reduce on its own: this one is inductive in `xs`.
#
# This law pins `reverse` on its own. The general form,
# `reverse(append(xs, ys)) == append(reverse(ys), reverse(xs))`, does not: a
# `reverse` whose body is `Nil{}` -- which ignores both its argument and every
# append -- reduces both sides of that law to `Nil{}`, so it satisfies it. Here
# the right-hand side is `x <> reverse(xs)`, so a body that drops the list
# differs from it for a variable `xs`.
law rev_append:
  for xs: List<Nat>
  for x: Nat
  {S.reverse(P.append(xs, x <> Nil{})) == x <> S.reverse(xs) : List<Nat>}
