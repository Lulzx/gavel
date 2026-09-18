import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the empty list has no odd elements. It is definitional -- the match on
# `Nil{}` answers `0n` without looking at the tail -- and it is the weak half:
# the constant body `0n` satisfies it.
law count_odd_nil:
  {S.count_odd(Nil{}) == 0n : Nat}

# LAW: adding one element on the right adds whether that element is odd.
# `append` matches on its first argument, so with a variable `xs` the goal does
# not reduce on its own: this one is inductive in `xs`, and it is the law that
# pins `count_odd`. The constant body `0n` fails it, because the right-hand side
# is then `is_odd(x)`, stuck on a variable `x`, and a body that counted elements
# rather than odd ones fails it too, for the same reason: `1n` is not
# `is_odd(x)`.
law count_odd_snoc:
  for xs: List<Nat>
  for x: Nat
  {S.count_odd(P.append(xs, x <> Nil{})) == S.count_odd(xs) + P.is_odd(x) : Nat}
