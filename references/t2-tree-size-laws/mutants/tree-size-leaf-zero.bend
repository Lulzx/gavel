import Base
import ./prelude.bend as P

# Hand-authored: the base case only. The leaf answers `0n` instead of `1n`.
#
# Not derived by `tools.mutate`: `tree_size_leaf` is the law whose left-hand
# side is a closed constructor term, and the generator's rules rewrite a step,
# never the answer a match has already stopped at.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing `tree_size_leaf`, `tree_size_nodes`
def tree_size(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{v}:
      0n
    case P.Node{l, key, r}:
      1n + tree_size(l) + tree_size(r)
