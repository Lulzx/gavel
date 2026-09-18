import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: adding one on the right is adding one on the left.
law add_one:
  for x: Nat
  {S.add(x, 1n) == 1n+x : Nat}

# LAW: addition is associative.
law add_assoc:
  for x: Nat
  for y: Nat
  for z: Nat
  {S.add(S.add(x, y), z) == S.add(x, S.add(y, z)) : Nat}
