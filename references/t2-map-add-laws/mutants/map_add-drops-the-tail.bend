import Base

# The head is added to and the tail is dropped, so every nonempty list maps to
# a one-cell list. The singleton law is satisfied and the append law is not.
# Measured: `proof_tier=3 bare_tier=2`, proven ['map_add_single'], first
# failure at `LAWS.map_add_append`.
def map_add(xs: List<Nat>, n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      +k = n
      (h + k) <> Nil{}
