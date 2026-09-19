import Base
import ./prelude.bend as P

# The reference solution: the outer match is on the tree and the inner match is
# on the depth, so that the depth decides what a node contributes. A tip is not
# a node, so it answers `0n` at every depth and there is nothing for the inner
# match to do. A bin is one node: at depth `0n` it answers `1n`, and at `1n + dp`
# it hands `dp` to both subtrees and adds the two answers, so descending costs
# exactly one level. The key a bin carries is not read: a count is not a sum.
def count_at_depth(t: P.Tree, d: Nat) -> Nat:
  match t:
    case P.Tip{}:
      0n
    case P.Bin{l, key, r}:
      match d:
        case 0n:
          1n
        case 1n++dp:
          count_at_depth(l, dp) + count_at_depth(t, dp)
