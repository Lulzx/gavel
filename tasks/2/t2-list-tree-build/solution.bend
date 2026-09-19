import Base
import ./prelude.bend as P

# TODO(policy): implement. `build(bs)` turns a list into a tree by recursing on
# the list: `Nil{}` becomes the sentinel leaf `P.Leaf{0n}`, and `h <> t` becomes
# a node whose left child is the one-leaf tree `P.Leaf{h}` and whose right child
# is the tree built from `t`. The result is a left-leaning comb -- the head of
# the list at the top of the right spine, the last element at its bottom.
def build(bs: List<&2, Nat>) -> P.Tree:
  ?TODO
