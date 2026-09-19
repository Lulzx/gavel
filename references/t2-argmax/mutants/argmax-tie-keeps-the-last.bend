import Base
import ./prelude.bend as P

# `argmax` takes the new position whenever the largest seen so far does not beat
# the head, so a tie moves the position and the answer is the *last* position of
# the largest element rather than the first. The value side is untouched: only
# the comparison the position is taken on is turned around.
#
# This file exists for a law that no generated mutant fails: the closed list
# with a tie below is a ground term, and no step rewrite reaches a comparison
# that is already decided between two literals. This is the reference with the
# decision reversed and nothing else, so it type-checks and every recursive call
# is untouched.
#
# Measured against this task's law set: tier 3, failing `argmax_go_step`,
# `argmax_tie` and `argmax_same`.
def argmax_go(xs: List<&2, Nat>, +cur: Nat, bi: Nat, +i: Nat) -> Nat:
  match xs:
    case Nil{}:
      bi
    case +h <> t:
      argmax_go(t, P.max2(h, cur), P.pick_if(P.gt(cur, h), bi, i), 1n + i)

def argmax(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      argmax_go(t, h, 0n, 1n)
