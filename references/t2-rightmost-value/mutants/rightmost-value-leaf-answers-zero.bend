import Base
import ./prelude.bend as P

# `rightmost_value` walks the right spine correctly but never reads the value it
# finds there: the leaf case answers `0n` instead of the value it carries, and
# the node case is the reference's.
#
# This file exists for a law that no generated mutant fails. The corpus rewrites
# a recursive step, and the leaf case is an answer a match that has already
# stopped gives -- it never recurses, so no step rewrite reaches it, and
# `rightmost_value_leaf` was killed only by corpus entries that fail to
# type-check. This is the reference with that one answer replaced, so it
# type-checks and the walk is otherwise untouched.
#
# Measured against this task's law set: tier 3, failing `rightmost_value_leaf`
# and `rightmost_value_mirror`.
def rightmost_value(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{v}:
      0n
    case P.Node{l, key, r}:
      rightmost_value(r)
