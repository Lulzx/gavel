import Base
import ./prelude.bend as P

# The reference solution: step on the first list and then on the second, so the
# recursion stops at whichever one runs out first, and add the product of the
# two heads to the walk over the two tails. `Nat.mul` is Base's own
# multiplication, which recurses on its first argument.
def dot(xs: List<Nat>, ys: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      match ys:
        case Nil{}:
          0n
        case k <> u:
          Nat.mul(h, k) + dot(u, t)
