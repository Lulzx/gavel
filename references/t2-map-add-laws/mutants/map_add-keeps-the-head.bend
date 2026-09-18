import Base

# The head is copied through unadded and only the tail is mapped, so the first
# cell never gets `n`. The singleton law asks for `h + n` at variables.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.map_add_single`.
def map_add(xs: List<Nat>, n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      h <> map_add(t, n)
