import Base
import ./prelude.bend as P

# The ceiling is ignored and the elements pass through unchanged, which is the
# reference with `P.max` left off. The singleton law refuses it.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.max_all_single`.
def max_all(xs: List<Nat>, n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      h <> max_all(t, n)
