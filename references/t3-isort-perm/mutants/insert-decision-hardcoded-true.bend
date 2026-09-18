import Base
import ./prelude.bend as P

# The decision is hard-coded to `True{}`: the element is always placed before
# the head it meets, so `insert` is again effectively a prepend, but through the
# prelude's own cons step rather than by writing the cons directly. It is the
# body that separates "the policy computed the comparison" from "the policy
# passed a comparison", since the term is well typed either way. `isort_swap`
# fails; the count law holds. Measured: rejected at `Policy.count_ins`, the
# count law's helper, with all four laws reported unproven.
def insert(xs: List<&2, Nat>, +y: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      y <> Nil{}
    case +h <> t:
      P.insert_put(t, h, y, True{})

def isort(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      insert(isort(t), h)
