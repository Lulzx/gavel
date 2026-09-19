import Base
import ./prelude.bend as P

# The reference: both trees are matched at once, so the walk steps them
# together. Two leaves answer `True{}` whatever they carry, a leaf against a
# node answers `False{}` either way round, and two nodes answer the `and` of the
# two subtree comparisons. Every value the patterns bind -- a leaf's `value` and
# an interior `key` -- is unread, which is what makes the answer a shape and not
# a comparison.
def same_shape(t1: P.Tree, t2: P.Tree) -> Bool:
  match t1 t2:
    case P.Leaf{v} P.Leaf{w}:
      True{}
    case P.Leaf{v} P.Node{l, key, r}:
      False{}
    case P.Node{l, key, r} P.Leaf{w}:
      False{}
    case P.Node{l1, key1, r1} P.Node{l2, key2, r2}:
      Bool.and(same_shape(l1, l2), same_shape(r2, r1))
