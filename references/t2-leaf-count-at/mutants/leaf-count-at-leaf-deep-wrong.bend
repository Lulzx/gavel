import Base
import ./prelude.bend as P

# `leaf_count_at` counts a leaf at every depth: the depth-zero answer is the
# reference's `1n`, and a leaf at `1n + kp` answers `1n` too, so a tree with one
# leaf has one leaf at every depth rather than only at its own.
#
# This file exists for the second half of the leaf's answers, which is the one
# law of the five whose right-hand side is a bare constant: a body that answered
# the leaf's `1n` at every depth satisfies the depth-zero anchor and the step law
# -- which never reaches a leaf -- and is separated only here.
#
# Measured against this task's law set: tier 3, killed by
# `leaf_count_at_leaf_deep` alone -- the one law of the five stated at a depth
# other than zero whose subject is a leaf, and so the only law this body's answer
# disagrees with.
def leaf_count_at(t: P.Tree, k: Nat) -> Nat:
  match t:
    case P.Leaf{v}:
      match k:
        case 0n:
          1n
        case 1n+kp:
          1n
    case P.Node{l, key, r}:
      match k:
        case 0n:
          0n
        case 1n++kp:
          leaf_count_at(l, kp) + leaf_count_at(r, kp)
