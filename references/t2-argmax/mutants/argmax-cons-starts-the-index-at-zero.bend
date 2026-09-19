import Base
import ./prelude.bend as P

# `argmax` starts the walk one position too early: the tail's first element is
# counted as position `0n`, so every answer after the head is one short.
#
# This file exists for a law that no generated mutant fails: the closed lists
# below are ground terms, so the generator -- whose mutants rewrite a step or
# swap case bodies -- never states one. This is the reference with the starting
# counter changed and nothing else, so it type-checks and every recursive call
# is untouched.
#
# Measured against this task's law set: tier 3, failing `argmax_cons`,
# `argmax_three` and `argmax_tie`.
def argmax_go(xs: List<&2, Nat>, +cur: Nat, bi: Nat, +i: Nat) -> Nat:
  match xs:
    case Nil{}:
      bi
    case +h <> t:
      argmax_go(t, P.max2(h, cur), P.pick_if(P.gt(h, cur), i, bi), 1n + i)

def argmax(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      argmax_go(t, h, 0n, 0n)
