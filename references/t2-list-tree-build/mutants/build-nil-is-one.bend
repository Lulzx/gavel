import Base
import ./prelude.bend as P

# The reference with the empty case given a leaf carrying `1n` instead of `0n`.
# The shape and the count are the reference's everywhere, and every list
# building to a non-empty tree has `1n` at the bottom of its spine -- so this
# differs from the reference only on the lists whose last element is not `1n`,
# and on the empty list.
#
# Measured 2026-09-19 under this task's own reference proof: tier 3, proving
# `build_cons`, `build_leaves` and `build_right_spine` and failing `build_nil`
# and `build_last`. The second hand mutant for the ground law: it is the same
# answer as the reference everywhere except at the case a stopped match gives.
def build(bs: List<&2, Nat>) -> P.Tree:
  match bs:
    case Nil{}:
      P.Leaf{1n}
    case h <> t:
      P.Node{P.Leaf{h}, build(t)}
