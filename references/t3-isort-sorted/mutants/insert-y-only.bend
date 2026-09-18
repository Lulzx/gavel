import Base
import ./prelude.bend as P

# `insert` drops the list and answers the element alone. `y <> Nil{}` is sorted
# whatever the input was, so the obvious law is blind to this body; the two
# literal-list laws are what contradict it -- `insert_le` wants `y <> x <> Nil{}`
# at `x <> Nil{}` and gets `y <> Nil{}`, and `insert_gt` wants the mirror.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `Policy.ins_top`. The body breaks the prelude step the four law proofs share,
# so the checker refuses on the helper before it reaches any law -- the laws
# that contradict it are the ones named above, but the refusal is attributed to
# the helper, and `laws_failed` lists all five.
def insert(xs: List<&2, Nat>, +y: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      y <> Nil{}
    case h <> t:
      y <> Nil{}

def isort(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      insert(isort(t), h)
