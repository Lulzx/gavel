import Base

# The step doubles the head and stops: the tail is dropped entirely, so
# `double_all` of any nonempty list is a one-cell list. The singleton law is
# satisfied and the append law is not.
# Measured: `proof_tier=3 bare_tier=2`, proven ['double_all_single'], first
# failure at `LAWS.double_all_append`.
def double_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      +h2 = h
      (h2 + h2) <> Nil{}
