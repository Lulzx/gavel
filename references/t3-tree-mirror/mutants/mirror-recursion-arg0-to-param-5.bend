import Base
import ./prelude.bend as P

# Both subtrees are used once here -- the leaves are carried across unchanged,
# and only the order of the children changes at each node.
def mirror(t: P.Tree) -> P.Tree:
  match t:
    case P.Leaf{v}:
      P.Leaf{v}
    case P.Node{l, r}:
      P.Node{mirror(t), mirror(l)}
