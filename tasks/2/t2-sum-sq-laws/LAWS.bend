import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: an empty list adds up to nothing. It is definitional -- the match on
# `Nil{}` answers `0n` without looking at the tail -- and it is the weak half:
# the constant body `0n` satisfies it.
law sq_sum_nil:
  {S.sq_sum(Nil{}) == 0n : Nat}

# LAW: adding one element on the right adds the square of that element. `append`
# matches on its first argument, so with a variable `xs` the goal does not
# reduce on its own: this one is inductive in `xs`, and it is the law that pins
# `sq_sum`. Alone it is satisfied by a body that summed the elements rather than
# their squares -- the right-hand side would have to be `sq(x)` exactly, and
# `x` is stuck -- and the constant body `0n` fails it for the same reason.
law sq_sum_snoc:
  for xs: List<Nat>
  for x: Nat
  {S.sq_sum(P.append(xs, x <> Nil{})) == S.sq_sum(xs) + P.sq(x) : Nat}
