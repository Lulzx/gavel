import Base
import ./prelude.bend as P

# The empty input is answered with a one-cell list holding `2n`. No law is
# stated at `Nil{}` directly: this is the escape probe, and the singleton law
# reaches it through the recursive call.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.succ2_all_single`.
def succ2_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      2n <> Nil{}
    case h <> t:
      P.succ2(h) <> succ2_all(t)
