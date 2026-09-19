import Base
import ./prelude.bend as P

# `internal_count` counts every node rather than the interior ones: the leaf
# case answers `1n` instead of `0n`, and the node case is the reference's.
#
# This file exists for a law that no generated mutant fails. The corpus rewrites
# a recursive step, and the leaf case is an answer a match that has already
# stopped gives -- it never recurses, so no step rewrite reaches it, and
# `internal_count_leaf` was killed only by corpus entries that fail to
# type-check. This is the reference with that one case given a non-empty answer
# -- `1n`, a leaf counted as a node -- so it type-checks and every recursive
# call is untouched. The wrong body is the shape of `tree_size`, which is the
# reading this task exists to separate from.
#
# Measured against this task's law set: tier 3, failing `internal_count_leaf`
# and `internal_count_inner`.
def internal_count(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{v}:
      1n
    case P.Node{l, key, r}:
      1n + internal_count(l) + internal_count(r)
