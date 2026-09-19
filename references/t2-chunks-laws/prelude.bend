import Base

# Immutable, and owned by the task rather than the policy. Both helpers append
# one thing at the end of a list, which is what a block being built needs: an
# element is added to the block in order, and a finished block is added to the
# list of blocks in order. `snoc` takes a `Nat` list and `push` takes a list of
# blocks, so the two are separate defs rather than one polymorphic one.

def snoc(xs: List<&2, Nat>, y: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      y <> Nil{}
    case h <> t:
      h <> snoc(t, y)

def push(blocks: List<&2, List<&2, Nat>>, blk: List<&2, Nat>) -> List<&2, List<&2, Nat>>:
  match blocks:
    case Nil{}:
      blk <> Nil{}
    case g <> gs:
      g <> push(gs, blk)
