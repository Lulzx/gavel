import Base
import ./prelude.bend as P

# Both subtrees and then the key: the walk ends on the root rather than on the
# rightmost key.
#
# False of `inorder_node` at `Bin{Tip{}, 2n, Bin{Tip{}, 3n, Tip{}}}`: the body
# answers `3n <> (2n <> Nil{})` there, and the law's right-hand side is
# `2n <> (3n <> Nil{})`. As with the other reorderings, the same body agrees
# with the reference at every node whose right subtree is empty, which is why
# the measure and the transport do not see it.
def inorder(t: P.Tree) -> List<&2, Nat>:
  match t:
    case P.Tip{}:
      Nil{}
    case P.Bin{l, key, r}:
      P.append(P.append(inorder(l), inorder(r)), key <> Nil{})
