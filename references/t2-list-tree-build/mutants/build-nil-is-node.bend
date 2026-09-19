import Base
import ./prelude.bend as P

# The reference with the empty case given a two-leaf node instead of the
# sentinel. Every cons case is the reference's, so the answer is the reference's
# tree with one extra node at the bottom of the spine, and its bottom carries
# `0n` either way.
#
# Measured 2026-09-19 under this task's own reference proof: tier 3, proving
# `build_cons` and `build_last` and failing `build_nil`, `build_leaves` and
# `build_right_spine`. `build_last` holds because the extra node's bottom leaf
# carries the same `0n` the sentinel would.
#
# This is a hand mutant for a law the base-case rule covers: `build_nil`'s
# left-hand side is the ground term `build(Nil{})`, which the generator's
# step-rewriting never reaches.
def build(bs: List<&2, Nat>) -> P.Tree:
  match bs:
    case Nil{}:
      P.Node{P.Leaf{0n}, P.Leaf{0n}}
    case h <> t:
      P.Node{P.Leaf{h}, build(t)}
