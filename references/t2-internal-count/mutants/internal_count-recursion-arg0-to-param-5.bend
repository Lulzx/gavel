import Base
import ./prelude.bend as P

# The reference: a leaf is not an interior node, so it answers `0n` and the
# value it carries is never read. A node is one interior node of its own --
# `1n` -- plus the interior nodes of both subtrees, left first. The key is bound
# by the pattern and never read.
def internal_count(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{v}:
      0n
    case P.Node{l, key, r}:
      1n + internal_count(t) + internal_count(r)
