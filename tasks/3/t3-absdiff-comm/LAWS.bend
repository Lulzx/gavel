import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: a difference from zero is the other number. It is a pin: a body that
# ignored its arguments -- `absdiff(a, b) = 0n`, or `= a` -- cannot satisfy it,
# because the left-hand side computes to `P.sub(b, 0n)` and the right-hand side
# is the variable `b`.
law absdiff_zero_left:
  for b: Nat
  {S.absdiff(0n, b) == b : Nat}

# LAW: a difference from zero on the other side is the number itself. The other
# half of the pin pair: `absdiff(a, b) = b` satisfies the law above and fails
# this one, so the two together are what rule out the projections.
law absdiff_zero_right:
  for a: Nat
  {S.absdiff(a, 0n) == a : Nat}

# LAW: a number's difference from itself is zero. This is the law that fixes
# what happens when both sides move together, and it is where the subtraction
# has to be unfolded on a *variable* pair rather than on a zero.
law absdiff_self:
  for a: Nat
  {S.absdiff(a, a) == 0n : Nat}

# LAW: the difference does not care which way round it is taken. Nothing above
# says anything about the order, so this is the law that pins it, and its two
# sides are the same two subtractions in the other order -- which is an
# addition that commutes, not an unfolding.
law absdiff_comm:
  for a: Nat
  for b: Nat
  {S.absdiff(a, b) == S.absdiff(b, a) : Nat}
