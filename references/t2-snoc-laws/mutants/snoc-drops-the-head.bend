import Base

# The cons case recurses without putting the head back, so a nonempty list
# comes back shorter by one cell. The nil law still holds.
# Measured: `proof_tier=3 bare_tier=2`, proven ['snoc_nil'], first failure
# at `LAWS.snoc_append`.
def snoc(xs: List<Nat>, x: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      x <> Nil{}
    case h <> t:
      snoc(t, x)
