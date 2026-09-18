import Base
import ./prelude.bend as P

# Only the head is reduced and the tail is handed back untouched. The
# singleton law cannot see it and the append law refuses it.
# Measured: `proof_tier=3 bare_tier=2`, proven ['sub_all_single'], first
# failure at `LAWS.sub_all_append`.
def sub_all(xs: List<Nat>, n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      +k = n
      P.sub(h, k) <> t
