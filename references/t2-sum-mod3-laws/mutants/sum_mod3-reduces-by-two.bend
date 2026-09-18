import Base
import ./prelude.bend as P

# The reduction is by two instead of three: the plausible slip of getting the
# divisor wrong. The nil law holds; the snoc law refuses it at a variable
# element, where `Nat.mod(x, 2n)` and `P.mod3(x)` are different terms.
# Measured: `proof_tier=3 bare_tier=2`, proven ['sum_mod3_nil'], first
# failure at `LAWS.sum_mod3_snoc`.
def sum_mod3(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      Nat.mod(h, 2n) + sum_mod3(t)
