import Base
import ./prelude.bend as P

# PROBE. The leaf case holds and the walk still ends at a carried value, but it
# descends the left subtree instead of the right -- the one-direction slip a
# body written from `P.leftmost`'s shape makes. It asks whether the law set pins
# which side the walk follows: the step law should separate it, and the mirror
# law should separate it again, because the two sides of `P.mirror(t)` are
# exchanged while this body answers the same value either way only when the two
# ends agree.
def rightmost_value(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{v}:
      v
    case P.Node{l, key, r}:
      rightmost_value(l)
