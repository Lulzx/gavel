import Base
import ./prelude.bend as P

# The walk answers one cell when the second list runs out.
#
# This file exists for a law that no other mutant in the corpus fails: the
# generator rewrites a *step*, and the walk's branch for an empty `ys` is an
# answer reached by a match on a literal. It is the reference with that one
# branch given a cell, so it type-checks and every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# `lcp_list_nil_right`.
def lcp_list(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> t:
      match ys:
        case Nil{}:
          1n <> Nil{}
        case k <> u:
          P.gate_list(P.is_eq(h, k), h <> lcp_list(t, u))
