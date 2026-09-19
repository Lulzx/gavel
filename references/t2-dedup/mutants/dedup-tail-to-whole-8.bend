import Base
import ./prelude.bend as P

# The reference solution: the outer match finds the first element and the inner
# match finds the second, and the decision goes to `same_put`. `h` is marked
# reusable because it appears both in the `same_put` call and in the decision
# handed to it; the tail is rebuilt as `h2 <> t2` so that the recursive call
# passes the shorter list rather than consuming the match binder twice.
def dedup(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> t:
      match t:
        case Nil{}:
          h <> Nil{}
        case +h2 <> t2:
          P.same_put(h, dedup(h2 <> t), P.same(h, h2))
