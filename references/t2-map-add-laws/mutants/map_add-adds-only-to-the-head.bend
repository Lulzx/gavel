import Base

# Only the head has `n` added to it and the tail is handed back untouched. The
# singleton law cannot see it and the append law refuses it.
# Measured: `proof_tier=3 bare_tier=2`, proven ['map_add_single'], first
# failure at `LAWS.map_add_append`.
def map_add(xs: List<Nat>, n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      +k = n
      (h + k) <> t
