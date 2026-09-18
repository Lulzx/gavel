import Base

# Every cell is answered with `1n` regardless of the element, which agrees
# with the reference only on a list of `0n`s. The singleton law fails at a
# variable `h`.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.inc_all_single`.
def inc_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      1n <> inc_all(t)
