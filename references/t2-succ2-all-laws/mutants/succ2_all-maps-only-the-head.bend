import Base
import ./prelude.bend as P

# Only the head is mapped; the tail is untouched. The singleton law cannot see
# it and the append law refuses it.
# Measured: `proof_tier=3 bare_tier=2`, proven ['succ2_all_single'], first
# failure at `LAWS.succ2_all_append`.
def succ2_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      P.succ2(h) <> t
