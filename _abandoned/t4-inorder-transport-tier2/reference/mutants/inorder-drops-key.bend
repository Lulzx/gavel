import Base
import ./prelude.bend as P

# Both subtrees and nothing between them: the key is dropped, so the answer is
# short by one element per node.
#
# False of `inorder_node` at `Bin{Bin{Tip{}, 1n, Tip{}}, 2n, Tip{}}`: the body
# answers `1n <> Nil{}` there, and the law's right-hand side is
# `P.append(S.inorder(l), key <> S.inorder(r))`, which is `1n <> (2n <> Nil{})`.
# `inorder_size` is false of it too, at the same tree -- the count is one short
# -- and the reference proof fails all three because it is written for the
# reference's step.
def inorder(t: P.Tree) -> List<&2, Nat>:
  match t:
    case P.Tip{}:
      Nil{}
    case P.Bin{l, key, r}:
      P.append(inorder(l), inorder(r))
