import Base
import ./prelude.bend as P

# The head is duplicated and the tail is dropped entirely, so every nonempty
# list maps to a two-cell list. The singleton law is satisfied and the append
# law is not.
# Measured: `proof_tier=3 bare_tier=2`, proven ['dup_all_single'], first
# failure at `LAWS.dup_all_append`.
def dup_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      +h2 = h
      h2 <> (h2 <> Nil{})
