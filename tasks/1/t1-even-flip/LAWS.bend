import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: adding one flips the parity.
law even_flip:
  for x: Nat
  {S.even(x) == Bool.not(S.even(1n+x)) : Bool}
