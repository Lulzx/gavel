import Base
import ./prelude.bend as P

# `leaf_count_at` answers `0n` at a leaf at depth zero: the tree is walked the
# reference's way, the depth still decides what a node contributes, and the leaf
# is counted as if it were an interior node -- so the answer is zero wherever a
# leaf stands alone, which is what the depth-zero half of a leaf's answers is
# about.
#
# This file exists for a law the generated corpus reaches only by copying the
# first case's answer into every case; the leaf at depth zero is the *first*
# case, so that rewrite leaves this answer alone. Everything else in the body is
# the reference's, so it type-checks.
#
# Measured against this task's law set: tier 3, killed by `leaf_count_at_leaf`
# and `leaf_count_at_root` -- the two laws whose subject is a leaf at depth zero
# -- and by nothing else, since every other law reaches either a deeper depth or
# an interior node.
def leaf_count_at(t: P.Tree, k: Nat) -> Nat:
  match t:
    case P.Leaf{v}:
      match k:
        case 0n:
          0n
        case 1n+kp:
          0n
    case P.Node{l, key, r}:
      match k:
        case 0n:
          0n
        case 1n++kp:
          leaf_count_at(l, kp) + leaf_count_at(r, kp)
