import Base
import ./prelude.bend as P

# The walk keeps one element after the first list has run out.
#
# This is the hand-written mutant the ground law `lcp_list_shorter_runs_out`
# needs: it states a closed pair of lists of different lengths, and it is the
# law that says the prefix stops where the shorter list stops rather than where
# the walk was told to stop. The walk here answers the element of the *second*
# list that the first list has nothing to match, which no reordering of the
# cells can produce. Every recursive step is untouched, so it type-checks.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# `lcp_list_nil_left`, `lcp_list_shorter_runs_out`.
def lcp_list(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      match ys:
        case Nil{}:
          Nil{}
        case k <> u:
          k <> Nil{}
    case +h <> t:
      match ys:
        case Nil{}:
          Nil{}
        case k <> u:
          P.gate_list(P.is_eq(h, k), h <> lcp_list(t, u))
