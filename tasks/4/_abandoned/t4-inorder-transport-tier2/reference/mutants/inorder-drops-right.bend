import Base
import ./prelude.bend as P

# The left traversal and the key only: the right subtree is dropped, so the
# answer keeps the first element of every subtree walk and loses the rest.
#
# False of `inorder_node` at `Bin{Tip{}, 2n, Bin{Tip{}, 3n, Tip{}}}`: the body
# answers `2n <> Nil{}` there, and the law's right-hand side is
# `P.append(S.inorder(l), key <> S.inorder(r))`, which is `2n <> (3n <> Nil{})`.
# Note that the same body agrees with the reference at
# `Bin{Bin{Tip{}, 1n, Tip{}}, 2n, Tip{}}`, where the right subtree is empty --
# which is what `inorder_size` is for, counting the whole answer rather than one
# node of it.
def inorder(t: P.Tree) -> List<&2, Nat>:
  match t:
    case P.Tip{}:
      Nil{}
    case P.Bin{l, key, r}:
      P.append(inorder(l), key <> Nil{})
