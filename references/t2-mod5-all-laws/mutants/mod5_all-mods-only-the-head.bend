import Base
import ./prelude.bend as P

# Only the head is reduced, and the tail is handed back untouched: the map is
# applied to the first cell alone. The singleton law cannot see it and the
# append law refuses it.
# Measured: `proof_tier=3 bare_tier=2`, proven ['mod5_all_single'], first
# failure at `LAWS.mod5_all_append`.
def mod5_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      P.mod5(h) <> t
