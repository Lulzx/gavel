import Base

# The empty input is answered with a one-cell list holding `0n`. No law is
# stated at `Nil{}` directly: this is the escape probe, and the singleton law
# reaches it through the recursive call.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.map_add_single`.
def map_add(xs: List<Nat>, n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      0n <> Nil{}
    case h <> t:
      +k = n
      (h + k) <> map_add(t, k)
