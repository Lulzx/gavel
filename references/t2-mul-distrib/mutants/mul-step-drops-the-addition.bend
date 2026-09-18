import Base

# The step recurses and never adds the multiplier back, so the product is zero
# for every pair: the recursion is present and its result is thrown away.
# Rejected by `mul_one_left` as a statement -- `mul(1n, x)` is `mul(0n, x)`,
# which is `0n`, where the law wants `x`. `mul_distrib` is true of the body,
# since zero distributes over addition, and the checker stops in `L.mul_one_left`
# all the same: its step is written for an answer that contains the predecessor.
def mul(a: Nat, +b: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      mul(p, b)
