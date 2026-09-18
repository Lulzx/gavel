import Base
import ./prelude.bend as P

# A right-to-left walk: the right traversal, the key, then the left one. The
# same elements, the opposite order.
#
# False of `inorder_node` at `Bin{Bin{Tip{}, 1n, Tip{}}, 2n, Tip{}}`: the body
# answers `2n <> (1n <> Nil{})` there, and the law's right-hand side is
# `P.append(S.inorder(l), key <> S.inorder(r))`, which is `1n <> (2n <> Nil{})`.
# `inorder_transport` is a conjunction over a permutation-blind fold and
# `inorder_size` only counts, so the step law is the one that sees it -- the
# reference proof fails all three for this body, because it is written for the
# reference's step and cannot follow a body whose append comes in the other
# order.
def inorder(t: P.Tree) -> List<&2, Nat>:
  match t:
    case P.Tip{}:
      Nil{}
    case P.Bin{l, key, r}:
      P.append(inorder(r), key <> inorder(l))
