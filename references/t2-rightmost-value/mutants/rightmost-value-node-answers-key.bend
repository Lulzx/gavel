import Base
import ./prelude.bend as P

# `rightmost_value` reads a number the tree carries at the node it is standing
# on rather than the one at the end of the walk: the node case answers the
# node's own `key`, and the leaf case is the reference's.
#
# This file exists because the node case is an answer the generated corpus never
# reaches with a well-typed body -- the step rewrites it makes either change the
# walk's argument to the whole tree, which does not terminate, or move a
# pattern binder out of the case that binds it. This is the reference with the
# step replaced by a number of the right type, so it type-checks.
#
# Measured against this task's law set: tier 3, failing `rightmost_value_node`
# and `rightmost_value_mirror`.
def rightmost_value(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{v}:
      v
    case P.Node{l, key, r}:
      key
