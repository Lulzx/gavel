import Base

# The element goes on the front instead of the end: the cons case answers
# `x <> h <> t`. The nil law is satisfied -- there the two coincide -- and the
# append law is not, because the first half is no longer left as it was.
# Measured: `proof_tier=3 bare_tier=2`, proven ['snoc_nil'], first failure
# at `LAWS.snoc_append`.
def snoc(xs: List<Nat>, x: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      x <> Nil{}
    case h <> t:
      x <> h <> t
