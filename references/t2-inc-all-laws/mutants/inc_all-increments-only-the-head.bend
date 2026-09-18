import Base

# Only the head is incremented and the tail comes back unchanged. The
# singleton law is satisfied -- the tail is `Nil{}` -- and the append law is
# not.
# Measured: `proof_tier=3 bare_tier=2`, proven ['inc_all_single'], first
# failure at `LAWS.inc_all_append`.
def inc_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      (h + 1n) <> t
