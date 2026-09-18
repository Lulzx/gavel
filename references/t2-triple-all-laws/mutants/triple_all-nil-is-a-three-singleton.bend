import Base
import ./prelude.bend as P

# The empty input is answered with a one-cell list holding `3n`. No law is
# stated at `Nil{}` directly: this is the escape probe, and the singleton law
# reaches it through the recursive call.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.triple_all_single`.
def triple_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      3n <> Nil{}
    case h <> t:
      P.triple(h) <> triple_all(t)
