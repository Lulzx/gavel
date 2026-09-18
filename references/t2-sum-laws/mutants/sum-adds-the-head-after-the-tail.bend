import Base

# The head is added after the recursion instead of before it. The body is the
# same function as the reference at the value level -- addition is commutative,
# so the two orders give the same total -- and it is rejected on proof shape
# alone: `sum_append` stops in its cons step, where the induction hypothesis
# expects the head to enter on the outside of the folded tail and the body has it
# inside, and `sum_single` stops in `L.sum_single`, whose `Policy.add_zero`
# rewrite looks for `h + 0n` where the body answers `0n + h`.
def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

def sum(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      sum(t) + h
