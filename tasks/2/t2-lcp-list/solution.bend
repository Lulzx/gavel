import Base
import ./prelude.bend as P

# TODO(policy): implement. `lcp_list(xs, ys)` is the longest common prefix of
# `xs` and `ys`, as a list: the leading elements the two lists have in common,
# stopping at the first position where they differ or at the end of whichever
# list runs out first. The answer is always a prefix of both inputs.
#
# The walk is on `xs` first, so the first list is the argument that shrinks and
# it comes first; the second list shrinks with it. The element in hand is read
# twice -- once into the comparison and once into the answer -- so it is
# declared reusable.
def lcp_list(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, Nat>:
  ?TODO
