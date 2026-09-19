import Base
import ./prelude.bend as P

# The reference with the two children swapped: the tail is built into the *left*
# child and the head's leaf is the right one. The answer is a right-leaning comb
# with the same elements in the opposite order along its spine, and it has the
# same number of leaves as the reference's.
#
# Measured 2026-09-19 under this task's own reference proof: tier 3, proving
# `build_nil` and failing the other four. `build_leaves` fails as well as
# `build_right_spine`: the extra leaf per element lands on the left of each
# node, so the two sides of the count are not even the same term.
def build(bs: List<&2, Nat>) -> P.Tree:
  match bs:
    case Nil{}:
      P.Leaf{0n}
    case h <> t:
      P.Node{build(t), P.Leaf{h}}
