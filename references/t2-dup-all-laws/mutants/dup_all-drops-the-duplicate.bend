import Base
import ./prelude.bend as P

# The head is put back once, so the body is the identity written through the
# pattern: the second copy of the head is missing. The singleton law fails.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.dup_all_single`.
def dup_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      h <> dup_all(t)
