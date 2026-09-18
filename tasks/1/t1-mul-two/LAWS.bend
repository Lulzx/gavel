import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: multiplying by zero is zero. This is the law that rejects a `mul` which
# ignores its *first* argument: `mul(a, b) = b + b` satisfies `mul_two` below,
# because with `a = 2n` it answers `x + x`, and it cannot answer `0n` here.
law mul_zero:
  for x: Nat
  {S.mul(0n, x) == 0n : Nat}

# LAW: multiplying by two is adding a number to itself. The `+` is Base's
# addition, not `S.add`, which is what makes the proof relate `S.add` to Base's
# `+` instead of every step being definitional.
#
# It pins nothing on its own, and the comment here used to claim it did. `mul(2n,
# x)` names its first argument as a literal, so any body that ignores that
# argument and answers `x + x` satisfies it: measured at tier 4 with `{==}` for
# both `mul(a, b) = b + b` and `add(a, b) = a + a`. `mul_zero` above and
# `add_zero` below are what close those two holes.
law mul_two:
  for x: Nat
  {S.mul(2n, x) == x + x : Nat}

# LAW: adding zero on the right changes nothing. This is what pins `add`, which
# no law mentioned on its own: `add(a, b) = a + a` makes `mul_two`'s goal
# `x + x == x + x` and fails here, and `add(a, b) = a` passes here and fails
# `mul_two`. Neither body is pinned by either law alone.
law add_zero:
  for x: Nat
  {S.add(x, 0n) == x : Nat}
