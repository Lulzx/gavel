import Base
import ./prelude.bend as P

# The tail's answer is returned and the head's test is never taken, so every
# list answers `True{}`. The nil law holds vacuously and the snoc law fails:
# its right-hand side keeps P.is_one_b(x) beside the recursive answer, and this
# body drops it.
# Measured: `proof_tier=3 bare_tier=2`, proven ['all_one_nil'], first
# failure at `LAWS.all_one_snoc`.
def all_one(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      True{}
    case h <> t:
      all_one(t)
