import Base
import ./prelude.bend as P

# `argmax` counts its positions from one when there is no list to walk: the
# empty list answers `1n` instead of `0n`.
#
# This file exists for a law that no generated mutant fails. The corpus's
# mutants that type-check rewrite a step or swap case bodies, and the answer at
# the empty list is an answer a match that has already stopped gives -- it
# recurses no further, so no step rewrite reaches it. This is the reference with
# that one case given a different answer, so it type-checks and every recursive
# call is untouched.
#
# Measured against this task's law set: tier 3, failing `argmax_nil` only.
def argmax_go(xs: List<&2, Nat>, +cur: Nat, bi: Nat, +i: Nat) -> Nat:
  match xs:
    case Nil{}:
      bi
    case +h <> t:
      argmax_go(t, P.max2(h, cur), P.pick_if(P.gt(h, cur), i, bi), 1n + i)

def argmax(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      1n
    case h <> t:
      argmax_go(t, h, 0n, 1n)
