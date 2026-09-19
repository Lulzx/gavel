import Base
import ./prelude.bend as P

# The tree the whole input was, hung under a new root whose right child is the
# new leaf. The new value is at the rightmost leaf and the leftmost leaf is
# where it was, so both value laws hold; the right spine is two nodes long
# whatever the input was, so `snoc_tree_right_spine` does not.
#
# Measured 2026-09-19 under this task's own reference proof: tier 3, proving
# `snoc_tree_rightmost` and `snoc_tree_leftmost` and failing
# `snoc_tree_right_spine` (`expected : 1n + (1n + ...) / observed : 2n`).
def snoc_tree(t: P.Tree, v: Nat) -> P.Tree:
  P.Node{t, P.Leaf{v}}
