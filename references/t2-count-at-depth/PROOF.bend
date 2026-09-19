import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The tree is a `P.Tip`, so the outer match takes the tip case and answers `0n`
# whatever the depth is: both sides are `0n`.
def L.count_at_depth_tip(d):
  {==}

# The depth is the literal `0n` and the tree is a variable, so the case split is
# on the tree: a tip is not a node and answers `0n`, and `P.is_tip` is `True{}`
# there; a bin is one node and answers `1n`, and `P.is_tip` is `False{}` there.
# Nothing is left over in either case, so no hypothesis is needed and the law is
# a case split rather than an induction.
def L.count_at_depth_zero(t):
  match t:
    case P.Tip{}:
      {==}
    case P.Bin{l, key, r}:
      {==}

# The tree is a `P.Bin`, so the outer match takes the bin case, and the depth
# `1n + d` takes the successor case, which hands `d` to both subtrees: both sides
# are the same sum.
def L.count_at_depth_step(l, key, r, d):
  {==}

# The tree is closed and the depth is the literal `1n`, so every match reduces:
# the two subtrees of the root are bins themselves, each contributes one at depth
# `0n`, and the sum is `2n` against itself.
def L.count_at_depth_three():
  {==}
