import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: reversing a list with one element added on the right puts that element on
# the left. `snoc` matches on its first argument, so with a variable `xs` the
# goal does not reduce on its own: this one is inductive in `xs`.
#
# This law pins `snoc` on its own. `snoc` ignores its arguments only by being
# `Nil{}`, which makes the left-hand side `Nil{}` while the right-hand side is
# `x <> reverse(xs)`; and returning `xs` instead makes it `reverse(xs)`. Both
# differ from `x <> reverse(xs)` for a variable `xs`.
law rev_snoc:
  for xs: List<Nat>
  for x: Nat
  {P.reverse(S.snoc(xs, x)) == x <> P.reverse(xs) : List<Nat>}
