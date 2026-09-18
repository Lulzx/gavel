import Base
import ./prelude.bend as P

# The ceiling is applied to the head and the tail is dropped: `max_all` of a
# nonempty list is a one-cell list. The singleton law is satisfied and the
# append law is not.
# Measured: `proof_tier=3 bare_tier=2`, proven ['max_all_single'], first
# failure at `LAWS.max_all_append`.
def max_all(xs: List<Nat>, n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      +k = n
      P.max(h, k) <> Nil{}
