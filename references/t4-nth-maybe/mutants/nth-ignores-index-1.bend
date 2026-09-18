import Base
import ./prelude.bend as P

# The step returns the head instead of taking it: `nth(1n + p, h <> t)` answers
# `Some{h}` where the reference recurses, so the answer stops depending on the
# index past the first element. `nth_zero` holds and the out-of-range law holds
# -- the answer is still `None{}` wherever the list has nothing. The law it is
# false of is the step: `Some{h}` against `nth(p, t)`, which is `None{}` as soon
# as the tail runs out. The domain law is true of it -- `Some{}` is the right
# branch wherever the index is in range -- but its proof is a recursion on the
# index that this body cannot follow, so it is not provable for it either.
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
