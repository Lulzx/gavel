import Base
import ./prelude.bend as P

# The empty input is answered with a one-cell list holding `1n`. No law is
# stated at `Nil{}` directly: this is the escape probe, and the singleton law
# reaches it through the recursive call.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.sq_inc_all_single`.
def sq_inc_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      1n <> Nil{}
    case h <> t:
      P.sq_inc(h) <> sq_inc_all(t)
