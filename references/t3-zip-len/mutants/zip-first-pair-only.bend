import Base
import ./prelude.bend as P

# The first pair is right and the recursion is gone: `zip` answers one pair
# whenever both lists are non-empty. Both pin laws hold (a one-element answer is
# exactly what they ask for at one-element inputs) and the length law is the one
# that fails, since the answer does not grow with the lists. Measured:
# `proof_tier=2 bare_tier=2`, nothing proven, first failure at `LAWS.zip_len`.
def zip(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, P.P2>:
  match xs:
    case Nil{}:
      Nil{}
    case hx <> tx:
      match ys:
        case Nil{}:
          Nil{}
        case hy <> ty:
          P.Mk{hx, hy} <> Nil{}
