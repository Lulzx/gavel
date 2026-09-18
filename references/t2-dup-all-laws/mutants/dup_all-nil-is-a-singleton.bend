import Base
import ./prelude.bend as P

# The empty input is answered with a one-cell list holding `0n`. No law is
# stated at `Nil{}` directly: this is the escape probe, and the singleton law
# reaches it through the recursive call.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.dup_all_single`.
def dup_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      0n <> Nil{}
    case h <> t:
      +h2 = h
      h2 <> (h2 <> dup_all(t))
