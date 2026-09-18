import Base
import ./prelude.bend as P

# Descends the left subtree only: the right one is dropped from the count. The
# leaf case is the reference's, and both other laws see it. `height_node`
# rejects it because its right side is `1n + P.max(S.height(l), S.height(r))`
# and this computes to `1n + S.height(l)`, which `P.max` does not reduce to while
# `S.height(l)` is a variable; `height_mirror` rejects it because a tree that
# leans right has a different height from its mirror under this body.
def height(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{}:
      0n
    case P.Node{l, r}:
      1n + height(l)
