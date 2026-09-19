import Base
import ./prelude.bend as P

# The reference solution: the outer match finds the first element and the inner
# match finds the second, so the one-element list is told from a longer one. The
# step adds the decision rather than branching on it -- `P.is_eq` answers `1n`
# for equal neighbours and `0n` otherwise, and `P.nsub(1n, ...)` turns that into
# one for a boundary and nothing for a continuation, with no `match` on a call.
# The second element is marked reusable because it appears both in the decision
# and in the list the recursive call is handed.
def count_runs(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      match t:
        case Nil{}:
          1n
        case +h2 <> t2:
          P.nsub(1n, P.is_eq(h2, h)) + count_runs(h2 <> t2)
