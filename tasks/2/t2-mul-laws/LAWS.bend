import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: one is a left identity for multiplication.
law mul_one_left:
  for x: Nat
  {S.mul(1n, x) == x : Nat}

# LAW: multiplying by a successor adds one more copy of the other factor.
law mul_succ:
  for x: Nat
  for y: Nat
  {S.mul(x, 1n+y) == S.add(S.mul(x, y), x) : Nat}
