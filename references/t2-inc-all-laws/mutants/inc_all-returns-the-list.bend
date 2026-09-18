import Base

# The list is returned unchanged, so the increment never happens. The
# singleton law asks for `(h + 1n) <> Nil{}`.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.inc_all_single`.
def inc_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      xs
