import Base

# The body is the second projection: the accumulator comes back untouched and
# the first list is discarded entirely. The singleton law asks for `h <> ys`.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.rev_append_single`.
def rev_append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      ys
