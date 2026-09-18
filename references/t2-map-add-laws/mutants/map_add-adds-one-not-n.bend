import Base

# One is added to every element instead of `n`, so the second argument is
# ignored. The singleton law asks for `h + n` and the body leaves `h + 1n`.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.map_add_single`.
def map_add(xs: List<Nat>, n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      (h + 1n) <> map_add(t, n)
