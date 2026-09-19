import Base
import ./prelude.bend as P

# The reference: step on the first list and then on the second, so the walk ends
# at whichever one runs out first, and decide the two heads with the prelude's
# comparisons. `P.lt(h, k)` answers `True{}` outright when the first head is
# below the second, and `P.eq(h, k)` gates the tails' own comparison so that a
# pair of differing heads is not read as a tie.
def lex_le(xs: List<&2, Nat>, ys: List<&2, Nat>) -> Bool:
  match xs:
    case Nil{}:
      True{}
    case h <> t:
      match ys:
        case Nil{}:
          False{}
        case k <> u:
          Bool.or(P.lt(h, k), Bool.and(P.eq(h, k), lex_le(xs, u)))
