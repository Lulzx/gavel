import Base

# The cons case answers `Nil{}`, so a nonempty first list reverses to nothing.
# The nil case is untouched and the singleton law fails.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.rev_append_single`.
def rev_append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      Nil{}
