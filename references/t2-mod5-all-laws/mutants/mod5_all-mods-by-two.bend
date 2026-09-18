import Base
import ./prelude.bend as P

# The reduction is by two instead of five. It is the plausible slip of getting
# the constant wrong, and the singleton law refuses it at a variable head,
# where `Nat.mod(h, 2n)` and `P.mod5(h)` do not reduce alike.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.mod5_all_single`.
def mod5_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      Nat.mod(h, 2n) <> mod5_all(t)
