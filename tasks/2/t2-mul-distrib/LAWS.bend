import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: one is a left identity for multiplication. Alone it does not pin `mul`:
# the projection `mul(a, b) = b` satisfies it.
law mul_one_left:
  for x: Nat
  {S.mul(1n, x) == x : Nat}

# LAW: multiplication distributes over addition on the left. Alone it does not
# pin `mul` either: the projection `mul(a, b) = a` satisfies it, since then both
# sides are `x + y`. Together the two laws do pin it -- `mul_one_left` kills
# that projection, and `mul_distrib` kills every constant.
law mul_distrib:
  for x: Nat
  for y: Nat
  for z: Nat
  {S.mul(x + y, z) == S.mul(x, z) + S.mul(y, z) : Nat}
