import Base
import ./prelude.bend as P

# Mutant: the leaf case answers `0n` instead of the number the leaf carries, so
# every tree reads as `0n` whatever it holds. Type-checks. The anchor law
# catches it -- the step law is stated at `P.Node{l, r}` and never reaches a
# leaf -- and the content law catches it too.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# tree_max_leaf, tree_max_flatten.
def tree_max(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{v}:
      0n
    case P.Node{l, r}:
      P.max(tree_max(l), tree_max(r))
