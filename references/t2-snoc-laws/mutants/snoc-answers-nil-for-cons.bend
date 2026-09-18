import Base

# A nonempty list is answered with the empty list, so the element is lost as
# well. The nil law still holds and the append law fails.
# Measured: `proof_tier=3 bare_tier=2`, proven ['snoc_nil'], first failure
# at `LAWS.snoc_append`.
def snoc(xs: List<Nat>, x: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      x <> Nil{}
    case h <> t:
      Nil{}
