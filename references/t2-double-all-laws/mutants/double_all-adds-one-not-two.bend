import Base

# The step adds one instead of doubling, so `double_all` increments. The
# singleton law asks for `h + h` and the body answers `h + 1n`.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.double_all_single`.
def double_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      (h + 1n) <> double_all(t)
