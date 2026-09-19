import Base
import ./prelude.bend as P

# The walk answers its counter when the list runs out, so it reports the
# position of the element it was about to look at rather than the position of
# the largest element it has already seen -- the last position of the list
# instead of the largest element's.
#
# This file exists for a law that no generated mutant fails: the generated
# mutants that type-check either rewrite the step, which this law never reaches,
# or answer a running value rather than the counter. This is the reference with
# the walk's empty case given a different answer, so it type-checks and every
# recursive call is untouched.
#
# Measured against this task's law set: tier 3, failing `argmax_go_nil`,
# `argmax_three`, `argmax_tie` and `argmax_same`.
def argmax_go(xs: List<&2, Nat>, +cur: Nat, bi: Nat, +i: Nat) -> Nat:
  match xs:
    case Nil{}:
      i
    case +h <> t:
      argmax_go(t, P.max2(h, cur), P.pick_if(P.gt(h, cur), i, bi), 1n + i)

def argmax(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      argmax_go(t, h, 0n, 1n)
