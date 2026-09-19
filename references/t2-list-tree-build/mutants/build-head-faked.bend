import Base
import ./prelude.bend as P

# The reference with a constant in place of the head's leaf: the shape, the
# count and the bottom of the spine are the reference's, and the head of the
# list is dropped on the floor.
#
# Measured 2026-09-19 under this task's own reference proof: tier 3, proving
# `build_nil`, `build_leaves`, `build_right_spine` and `build_last` and failing
# `build_cons` -- the count, the shape and the bottom of the spine are all the
# reference's, and only the definitional law about the cons case sees the head.
def build(bs: List<&2, Nat>) -> P.Tree:
  match bs:
    case Nil{}:
      P.Leaf{0n}
    case h <> t:
      P.Node{P.Leaf{0n}, build(t)}
