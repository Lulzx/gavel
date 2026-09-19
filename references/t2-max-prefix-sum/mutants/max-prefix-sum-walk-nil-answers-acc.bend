import Base
import ./prelude.bend as P

# HAND MUTANT. Target: `mpg_nil`. The walk's empty case has no prefix left to
# consider, so it answers the best running value; this body answers the running
# sum there instead -- the reading that takes `max_prefix_sum` for the sum of
# the whole list and the `best` slot for a value nobody ever reads. It is an
# answer the match has already stopped to give, so no recursive-step rewrite
# reaches it: the generated corpus never exercises this law, and every other law
# here is satisfied by the body, because `best` is still folded normally and the
# walk is still started at zero.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.h2.json check
# t2-max-prefix-sum --solution <this file> --proof
# references/t2-max-prefix-sum/PROOF.bend --backend plain --json`: **tier 3**,
# `laws_failed = ["mpg_nil"]`. One law, and it is the whole kill list: the
# generated corpus's three type-checking mutants all rewrite a recursive step,
# and this is a base case.
def max_prefix_sum_go(xs: List<&2, Nat>, +acc: Nat, best: Nat) -> Nat:
  match xs:
    case Nil{}:
      acc
    case +h <> t:
      max_prefix_sum_go(t, Nat.add(acc, h), P.max2(Nat.add(acc, h), best))

def max_prefix_sum(xs: List<&2, Nat>) -> Nat:
  max_prefix_sum_go(xs, 0n, 0n)
