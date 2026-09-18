import Base
import ./prelude.bend as P

# The empty list is answered `True{}` instead of `False{}`. This is the
# nil-case probe: `has_mult3_nil` is the one law stated at `Nil{}` directly, so it
# is the law that has to refuse it.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.has_mult3_nil`.
def has_mult3(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      True{}
    case h <> t:
      Bool.or(P.is_mult3_b(h), has_mult3(t))
