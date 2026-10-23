import Base
import ./prelude.bend as P

# A body a person would plausibly write: the recursion passes the count it was
# given rather than the decremented one, so no matter where the prefix ends the
# walk carries on to the end of the list. It is right on the diagonal the length
# law states -- a count at least the length walks the whole list either way -- so
# the three original laws accept it (`tools/holes.py`: wrong at
# `count_odd_prefix(1n, [2n, 1n, 2n])`). Rejected by `count_odd_prefix_step`.
def count_odd_prefix(n: Nat, xs: List<Nat>) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+k:
      match xs:
        case Nil{}:
          0n
        case h <> t:
          P.is_odd(h) + count_odd_prefix(n, t)
