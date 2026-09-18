import Base
import ./prelude.bend as P

# The comparison is hard-coded to `True{}`: the element always goes before the
# head it meets, so `insert` is a prepend wherever the list is non-empty. The
# prelude's own cons step is still called, which is what makes this the body
# that separates "the policy computed the comparison" from "the policy passed
# one". `insert_gt` is the law it contradicts -- its hypothesis is the decision
# `False{}` and this body never answers that. Measured: `proof_tier=2
# bare_tier=2`, nothing proven, first failure at `Policy.ins_top`, all five laws
# listed as failed: breaking the shared step refuses the run before any law is
# checked.
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
