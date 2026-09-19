import Base
import ./prelude.bend as P

# A preorder-shaped walk: the key in front of the left traversal, then the right
# one. This is the body the law set had to be changed for. It agrees with an
# inorder walk on the count, and on the leftmost element -- at a node whose left
# subtree traverses to the empty list it answers `key <> inorder(r)`, which is
# exactly where a traversal starts -- and the transport is blind to permutations
# because it is a conjunction. So `inorder_transport` and `inorder_size` are both
# true of it and `inorder_node` is what rejects it.
#
# False of `inorder_node` at `Bin{Bin{Tip{}, 1n, Tip{}}, 2n, Tip{}}`: the body
# answers `2n <> (1n <> Nil{})` there, and the law's right-hand side is
# `1n <> (2n <> Nil{})`.
def inorder(t: P.Tree) -> List<&2, Nat>:
  match t:
    case P.Tip{}:
      Nil{}
    case P.Bin{l, key, r}:
      P.append(key <> inorder(l), inorder(r))
