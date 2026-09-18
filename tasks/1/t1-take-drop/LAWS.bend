import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the first `n` elements of a list followed by the rest of it are the
# whole list. `take` matches on its first argument, so with a variable `xs` the
# goal does not reduce on its own: this one is inductive in `xs`, and the `n`
# case splits inside it.
#
# This law pins `take` on its own, and it pins the *whole* function rather than
# its length: the only bodies that ignore `xs` are `Nil{}` and `xs`, and neither
# satisfies it for a variable `xs` once `n` is `0n`.
law take_drop:
  for xs: List<Nat>
  for n: Nat
  {P.append(S.take(xs, n), P.drop(xs, n)) == xs : List<Nat>}
