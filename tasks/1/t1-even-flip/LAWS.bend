import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: adding one flips the parity.
law even_flip:
  for x: Nat
  {S.even(x) == Bool.not(S.even(1n+x)) : Bool}

# LAW: zero is even. Every other law here is relative -- each compares `even`
# with itself at a different argument -- and a whole family of bodies satisfies
# a relative set: the body that answers `False{}` at `0n` and flips from there
# proves `even_flip` exactly as the reference does, because both sides are
# negated together. Measured: tier 4, reward 1.000. This law fixes the value at
# a closed term, which is the one thing `even_flip` cannot do.
law even_zero:
  for x: Nat
  {S.even(0n) == True{} : Bool}
