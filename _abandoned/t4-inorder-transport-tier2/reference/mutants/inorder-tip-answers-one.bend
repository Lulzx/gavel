import Base
import ./prelude.bend as P

# The step is the reference's; only the empty tree's answer is wrong. Not a slip
# a person is likely to make on its own -- the traversal of the empty tree is
# visibly the empty list -- and it is in the corpus as the witness for the two
# laws that reach `Tip{}`, which `inorder_node` cannot: it says nothing about a
# node that is not a `Bin`, so the step law is not what rejects this body.
#
# False of `inorder_size` at `Tip{}`: the answer's length is `1n` where
# `P.size(P.Tip{})` is `0n`. False of `inorder_transport` as well, and for the
# same reason -- the answer is not empty, so the boundedness it asks for is not
# vacuous: at `b = 0n` the conclusion is `P.le(1n, 0n) == True{}`, which is
# `False{} == True{}`.
def inorder(t: P.Tree) -> List<&2, Nat>:
  match t:
    case P.Tip{}:
      1n <> Nil{}
    case P.Bin{l, key, r}:
      P.append(inorder(l), key <> inorder(r))
