import Base
import ./prelude.bend as P

# The walk: the empty list answers the best running value, and a cons cell adds
# its head to the running sum, keeps whichever of the new sum and the best so
# far is larger, and recurses on the tail.
def max_prefix_sum_go(xs: List<&2, Nat>, +acc: Nat, best: Nat) -> Nat:
  match xs:
    case Nil{}:
      best
    case +h <> t:
      max_prefix_sum_go(t, Nat.add(acc, h), P.max2(Nat.add(h, acc), best))

# The answer is the walk started with nothing accumulated and the empty prefix
# already standing as the best.
def max_prefix_sum(xs: List<&2, Nat>) -> Nat:
  max_prefix_sum_go(xs, 0n, 0n)
