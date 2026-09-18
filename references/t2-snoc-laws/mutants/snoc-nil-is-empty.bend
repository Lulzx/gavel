import Base

# The empty input is answered with the empty list rather than `x <> Nil{}`.
# This is the nil-case probe: `snoc_nil` is the one law stated at `Nil{}`
# directly, so it is the law that has to refuse it.
# Measured: `proof_tier=3 bare_tier=2`, proven ['snoc_append'], first
# failure at `LAWS.snoc_nil`.
def snoc(xs: List<Nat>, x: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      h <> snoc(t, x)
