import Base
import ./prelude.bend as P

# The tail's answer is returned and the head's test is never taken, so every
# list answers `True{}`. The nil law holds vacuously and the snoc law fails:
# its right-hand side keeps P.is_mult5_b(x) beside the recursive answer, and this
# body drops it.
# Measured: `proof_tier=3 bare_tier=2`, proven ['all_mult5_nil'], first
# failure at `LAWS.all_mult5_snoc`.
def all_mult5(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      True{}
    case h <> t:
      all_mult5(t)
