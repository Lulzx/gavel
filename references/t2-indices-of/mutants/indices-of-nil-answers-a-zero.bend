import Base
import ./prelude.bend as P

# `indices_of` reports a position even when there is nothing left to search: the
# empty list answers `0n` consed onto the empty list, so an exhausted search
# still leaves a `0n` behind.
#
# This file exists for a law that no generated mutant fails. The corpus's
# mutants that type-check rewrite a step or swap case bodies, and the answer at
# the empty list is an answer a match that has already stopped gives -- it
# recurses no further, so no step rewrite reaches it. This is the reference with
# that one case given a non-empty answer, so it type-checks and every recursive
# call is untouched.
#
# Measured against this task's law set: tier 3, failing `indices_of_nil` and
# `indices_of_miss`.
def indices_of(xs: List<Nat>, +k: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      0n <> Nil{}
    case h <> t:
      P.cons_if(P.eq(h, k), 0n, P.inc_all(indices_of(t, k)))
