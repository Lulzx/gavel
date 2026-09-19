import Base
import ./prelude.bend as P

# HAND MUTANT. Target: `max_prefix_sum_nil` and `max_prefix_sum_walk`. The
# answer is the walk started with the empty prefix already standing as the best,
# so both running values start at `0n`; this body starts the best at `1n`
# instead -- a walk seeded with a floor of one rather than with the empty
# prefix, the reading that treats every prefix as non-empty. The walk itself is
# untouched, so the two walk laws hold; the two laws that reach the wrapper's
# seed are the ones that fall.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.h2.json check
# t2-max-prefix-sum --solution <this file> --proof
# references/t2-max-prefix-sum/PROOF.bend --backend plain --json`: **tier 3**,
# `laws_failed = ["max_prefix_sum_nil", "max_prefix_sum_walk"]`. Two laws, and
# no walk law: the walk's own definition is the reference's, so only the two
# laws that reach the wrapper's seed separate it. The three laws that mention
# an interior or a closed list survive because `P.max2` flushes the seeded `1n`
# at the first head.
def max_prefix_sum_go(xs: List<&2, Nat>, +acc: Nat, best: Nat) -> Nat:
  match xs:
    case Nil{}:
      best
    case +h <> t:
      max_prefix_sum_go(t, Nat.add(acc, h), P.max2(Nat.add(acc, h), best))

def max_prefix_sum(xs: List<&2, Nat>) -> Nat:
  max_prefix_sum_go(xs, 0n, 1n)
