import Base
import ./prelude.bend as P

# Both subtrees are used once, and the leaf's value is put in front of the empty
# list so that the left subtree's leaves come out before the right one's.
def flatten(t: P.Tree) -> List<&2, Nat>:
  match t:
    case P.Leaf{v}:
      v <> Nil{}
    case P.Node{l, r}:
      P.append(flatten(l), flatten(r))
