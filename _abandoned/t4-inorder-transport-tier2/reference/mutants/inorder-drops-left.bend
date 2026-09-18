import Base
import ./prelude.bend as P

# The key and the right subtree only: the left subtree is dropped, and `l` is
# bound and never used.
#
# False of `inorder_node` at `Bin{Bin{Tip{}, 1n, Tip{}}, 2n, Tip{}}`: the body
# answers `2n <> Nil{}` there, and the law's right-hand side is
# `P.append(S.inorder(l), key <> S.inorder(r))`, which is `1n <> (2n <> Nil{})`.
# `inorder_size` is false of it too, at the same tree, and it is the law that
# would still see the mistake if the dropped subtree were balanced by a repeated
# one.
def inorder(t: P.Tree) -> List<&2, Nat>:
  match t:
    case P.Tip{}:
      Nil{}
    case P.Bin{l, key, r}:
      key <> inorder(r)
