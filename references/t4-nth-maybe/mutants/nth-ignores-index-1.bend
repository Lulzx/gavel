import Base
import ./prelude.bend as P

# The step returns the head instead of taking it: `nth(1n + p, h <> t)` answers
# `Some{h}` where the reference recurses, so the answer stops depending on the
# index past the first element. `nth_zero` holds and the out-of-range law holds
# -- the answer is still `None{}` wherever the list has nothing -- and it is
# `nth_succ` that rejects it, comparing `Some{h}` against `nth(p, t)`, which is
# `None{}` as soon as the tail runs out.
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
          Some{h}
