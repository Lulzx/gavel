import Base

# Adding to a nonempty list answers the one-element list `x <> Nil{}` and
# drops the list entirely, which the law comment names as the body the append
# law exists to refuse.
# Measured: `proof_tier=3 bare_tier=2`, proven ['snoc_nil'], first failure
# at `LAWS.snoc_append`.
def snoc(xs: List<Nat>, x: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      x <> Nil{}
    case h <> t:
      x <> Nil{}
