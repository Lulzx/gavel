import Base
import ./prelude.bend as P

# The index is consumed first and the list inside each branch: `nth` cannot
# match the list and then the index, since a nested `match` on a variable the
# outer pattern did not bind is refused ("match scrutinees in binder order").
# The walk is the obvious one -- `0n` reads the head, `1n + p` steps over it --
# and the empty list answers `None{}` at every index, which is what the
# out-of-range law pins.
def nth(k: Nat, xs: List<&2, Nat>) -> Maybe<&2, Nat>:
  match k:
    case 0n:
      match xs:
        case Nil{}:
          None{}
        case h <> t:
          Some{h}
    case 1n+p:
      match xs:
        case Nil{}:
          None{}
        case h <> t:
          nth(p, t)
