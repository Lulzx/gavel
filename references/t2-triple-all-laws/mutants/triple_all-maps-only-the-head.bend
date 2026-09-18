import Base
import ./prelude.bend as P

# Only the head is mapped and the tail is handed back untouched. The singleton
# law cannot see it and the append law refuses it.
# Measured: `proof_tier=3 bare_tier=2`, proven ['triple_all_single'], first
# failure at `LAWS.triple_all_append`.
def triple_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      P.triple(h) <> t
