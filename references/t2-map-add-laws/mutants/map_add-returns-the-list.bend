import Base

# The list comes back unchanged: the addend is never added. The singleton law
# asks for `(h + n) <> Nil{}` and `h + n` is stuck on the two variables.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.map_add_single`.
def map_add(xs: List<Nat>, n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      xs
