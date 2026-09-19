import Base
import ./prelude.bend as P

# `internal_count` walks both subtrees and never counts the node it is standing
# on: the leaf case is the reference's `0n`, and the node case answers the two
# subtrees' counts without its own `1n`.
#
# This file exists because the node case is an answer the corpus reaches only
# through a step rewrite, and the step rewrites it makes -- swapping the case
# bodies, passing the whole tree where a subtree belongs -- do not single out the
# node's own contribution. This is the reference with that contribution dropped,
# so it type-checks and the recursion is otherwise untouched.
#
# Measured against this task's law set: tier 3, failing `internal_count_node`
# and `internal_count_inner`.
def internal_count(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{v}:
      0n
    case P.Node{l, key, r}:
      internal_count(l) + internal_count(r)
