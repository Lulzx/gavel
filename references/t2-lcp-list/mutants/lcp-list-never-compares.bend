import Base
import ./prelude.bend as P

# The walk never compares the two heads.
#
# This is the hand-written mutant the ground law
# `lcp_list_stops_at_a_mismatch` needs: it states a closed pair of lists that
# agree twice and differ at the third position, and it is the law that says the
# element the lists disagree at is not in the answer. The body here keeps the
# cell unconditionally and walks on, so it answers the prefix of the shorter
# list rather than the common prefix -- it agrees with the reference on
# `lcp_list_shorter_runs_out` and on the law of a list with itself, and differs
# exactly where the two lists part. Every recursive step is untouched, so it
# type-checks.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# `lcp_list_cons_heads`, `lcp_list_self`, `lcp_list_stops_at_a_mismatch`. The
# law of a list with itself goes too, because its proof is carried by the gate
# that this body drops rather than by the cells it answers.
def lcp_list(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> t:
      match ys:
        case Nil{}:
          Nil{}
        case k <> u:
          h <> lcp_list(t, u)
