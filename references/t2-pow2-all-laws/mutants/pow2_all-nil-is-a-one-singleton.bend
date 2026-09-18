import Base
import ./prelude.bend as P

# The empty input is answered with a one-cell list holding `1n`. No law is
# stated at `Nil{}` directly: this is the escape probe, and the singleton law
# reaches it through the recursive call, which is what has to refuse it.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.pow2_all_single`.
def pow2_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      1n <> Nil{}
    case h <> t:
      P.pow2(h) <> pow2_all(t)
