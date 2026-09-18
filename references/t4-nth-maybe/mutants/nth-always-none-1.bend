import Base
import ./prelude.bend as P

# The walk is right and the answer is always `None{}`, so `nth` is the constant
# that says the list has nothing at any index. Both domain laws reject it: the
# out-of-range one because it is trivially satisfied, and `nth_some`, on any
# index the list does have -- `False{}` is not `True{}`. `nth_zero` rejects it
# first, on a cons at `0n`, where the two sides are `None{}` and `Some{h}`.
def nth(k: Nat, xs: List<&2, Nat>) -> Maybe<&2, Nat>:
  match k:
    case 0n:
      match xs:
        case Nil{}:
          None{}
        case h <> t:
          None{}
    case 1n+p:
      match xs:
        case Nil{}:
          None{}
        case h <> t:
          nth(p, t)
