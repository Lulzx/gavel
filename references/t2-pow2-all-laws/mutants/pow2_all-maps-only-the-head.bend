import Base
import ./prelude.bend as P

# Only the head is mapped; the tail is handed back untouched, so every cell
# after the first is left as the input had it. The singleton law cannot see
# this and the append law refuses it.
# Measured: `proof_tier=3 bare_tier=2`, proven ['pow2_all_single'], first
# failure at `LAWS.pow2_all_append`.
def pow2_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      P.pow2(h) <> t
