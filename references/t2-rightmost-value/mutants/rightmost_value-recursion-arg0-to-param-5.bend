import Base
import ./prelude.bend as P

# The reference: a leaf is its own rightmost leaf and answers the value it
# carries. A node answers whatever its right subtree answers -- the walk follows
# the right spine, the node's key is never read, and the left subtree is never
# entered.
def rightmost_value(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{v}:
      v
    case P.Node{l, key, r}:
      rightmost_value(t)
