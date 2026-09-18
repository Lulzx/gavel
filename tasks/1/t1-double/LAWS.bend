import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: doubling is adding a number to itself.
law double_eq_add:
  for x: Nat
  {S.double(x) == S.add(x, x) : Nat}

# LAW: one more on the argument is two more on the result. This is the step
# `double` recurses with, so it closes by reduction; it is what keeps the pair
# from being satisfied by a `double` that ignores its argument.
law double_succ:
  for x: Nat
  {S.double(1n+x) == 1n+1n+S.double(x) : Nat}
