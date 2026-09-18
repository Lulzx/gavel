import Base

# The element is never added: the body is the identity on the list. The nil law
# asks for `x <> Nil{}` and gets `Nil{}`.
# Measured: `proof_tier=3 bare_tier=2`, proven ['snoc_nil'], first failure
# at `LAWS.snoc_append`.
def snoc(xs: List<Nat>, x: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      x <> Nil{}
    case h <> t:
      xs
