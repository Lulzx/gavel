import Base
import ./prelude.bend as P

# The head is put in front of the sorted tail instead of being inserted into
# it: the recursion is right and `insert` is never called, so the body is the
# identity on every list. A permutation law cannot see that, and neither can a
# count; the pair that arrives in the wrong order comes back in the wrong
# order, so `isort_swap` fails. Measured: rejected at `LAWS.isort_count` first,
# with `insert_count` proven in isolation and the other three failing.
def insert(xs: List<&2, Nat>, +y: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      y <> Nil{}
    case +h <> t:
      P.insert_put(t, h, y, P.le(y, h))

def isort(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      h <> isort(t)
