import Base

# The cons case answers the empty list, so only the empty input has an answer
# and `double_all_single` fails at its own `(h + h) <> Nil{}`.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.double_all_single`.
def double_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      Nil{}
