import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: multiplying by one on the right changes nothing.
law mul_one:
  for x: Nat
  {S.mul(x, 1n) == x : Nat}

# LAW: the step `mul` recurses with, for a successor on the left. It closes by
# reduction; it is what keeps the pair from being satisfied by a `mul` that
# ignores its second argument.
law mul_succ:
  for x: Nat
  for y: Nat
  {S.mul(1n+x, y) == S.add(y, S.mul(x, y)) : Nat}
