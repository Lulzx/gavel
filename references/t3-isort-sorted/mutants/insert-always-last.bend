import Base
import ./prelude.bend as P

# The mirror body: the comparison is hard-coded to `False{}`, so the element
# always goes after the head it meets and `insert` appends to a list it does
# not inspect. `insert_le` is the law it contradicts -- with the hypothesis
# `le(y, x) == True{}` the law wants `y <> x <> Nil{}` and this body answers
# `x <> y <> Nil{}`. Measured: `proof_tier=2 bare_tier=2`, nothing proven,
# first failure at `Policy.ins_top`, all five laws listed as failed.
def insert(xs: List<&2, Nat>, +y: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      y <> Nil{}
    case +h <> t:
      P.insert_put(t, h, y, False{})

def isort(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      insert(isort(t), h)
