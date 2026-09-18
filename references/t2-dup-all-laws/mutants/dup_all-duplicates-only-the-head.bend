import Base
import ./prelude.bend as P

# The head is duplicated and the tail is handed back as it was: the recursion
# is never asked to duplicate anything. The singleton law cannot see it --
# there the tail is `Nil{}` -- and the append law refuses it.
# Measured: `proof_tier=3 bare_tier=2`, proven ['dup_all_single'], first
# failure at `LAWS.dup_all_append`.
def dup_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      +h2 = h
      h2 <> (h2 <> t)
