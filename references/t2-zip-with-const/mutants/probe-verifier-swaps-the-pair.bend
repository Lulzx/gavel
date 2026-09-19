import Base
import ./prelude.bend as P

# PROBE. The empty case holds, the list is walked once, and every element comes
# out packed with the constant -- but the two components are the other way
# round: the constant is the first and the element the second. That is the slip
# a body written from `P.MkPair`'s declaration without reading which component
# the task asks for makes, and it asks whether the law set pins which half of
# the pair is which.
#
# Measured against this task's law set: tier 3, failing `zip_with_const_step`,
# `zip_with_const_fsts` and `zip_with_const_snds`. The step separates it because
# the answered pair is `P.MkPair{k, h}` where the law says `P.MkPair{h, k}`, and
# the two component laws separate it again on their own: `P.fsts` then reads out
# the constant and `P.snds` the input, so the answer's halves are swapped against
# both of the laws that say which is which.
def zip_with_const(xs: List<Nat>, +k: Nat) -> List<&2, P.Pair>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      P.MkPair{k, h} <> zip_with_const(t, k)
