import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: an empty list adds up to nothing. It is definitional -- the match on
# `Nil{}` answers `0n` without looking at the tail -- and it is the weak half:
# the constant body `0n` satisfies it.
law sum_dec2_nil:
  {S.sum_dec2(Nil{}) == 0n : Nat}

# LAW: adding one element on the right adds the element minus two, saturating at zero of that element. `append`
# matches on its first argument, so with a variable `xs` the goal does not
# reduce on its own: this one is inductive in `xs`, and it is the law that pins
# `sum_dec2`. Alone it is satisfied by a body that added up the elements
# themselves -- the right-hand side would have to be `dec2(x)` exactly, and `x`
# is stuck -- and the constant body `0n` fails it for the same reason.
law sum_dec2_snoc:
  for xs: List<Nat>
  for x: Nat
  {S.sum_dec2(P.append(xs, x <> Nil{})) == S.sum_dec2(xs) + P.dec2(x) : Nat}
