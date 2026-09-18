import Base
import ./prelude.bend as P

# Only the head is mapped; the tail is untouched. The singleton law cannot see
# it and the append law refuses it.
# Measured: `proof_tier=3 bare_tier=2`, proven ['sq_inc_all_single'], first
# failure at `LAWS.sq_inc_all_append`.
def sq_inc_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      P.sq_inc(h) <> t
