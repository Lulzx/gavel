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

# LAW: the interior step. The four laws above pin `absdiff` on the two axes and
# on the diagonal, and those three lines do not determine the function between
# them: nothing above relates `absdiff(a, b)` to `absdiff(a-1, b-1)`, so every
# point off the axes and off the diagonal is free. **Measured 2026-09-19:** a
# body that answers the reference value *plus its own product with the smaller
# argument* -- `E + E * min(a, b)` for `E = P.sub(a, b) + P.sub(b, a)` -- is
# symmetric, vanishes on the diagonal (where `E` is `0n`), and answers `b` and
# `a` on the two axes (where `min` is `0n`), so it satisfies all four laws, and
# it is wrong: it answers `2n` where the reference answers `1n`.
#
# The demonstration is weaker than the other holes in this bank and is stated
# plainly. Against the reference proof the body reads **tier 2**: `absdiff_comm`'s
# step is `Policy.add_comm(P.sub(a, b), P.sub(b, a))`, which rewrites a subterm
# the reference body *is* rather than one it *contains*, so no body but the
# reference's own can clear it. The claim here rests on the laws, checked by hand
# on both axes, the diagonal and the symmetry, not on a mechanised 1.000 -- the
# same position as `t4-bst-insert` in Fact 34.
#
# This law is the missing interior: `sub` steps on both arguments at once, so
# `absdiff(1n + x, 1n + y)` reduces to `absdiff(x, y)` and the whole function
# follows from the axes by induction on the smaller argument.
law absdiff_succ_succ:
  for x: Nat
  for y: Nat
  {S.absdiff(1n + x, 1n + y) == S.absdiff(x, y) : Nat}
