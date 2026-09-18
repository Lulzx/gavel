import Base
import ./prelude.bend as P

# Only the head is mapped; the tail is handed back untouched. The singleton law
# cannot see it -- there the tail is `Nil{}` -- and the append law refuses it.
# Measured: `proof_tier=3 bare_tier=2`, proven ['cube_all_single'], first
# failure at `LAWS.cube_all_append`.
def cube_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      P.cube(h) <> t
