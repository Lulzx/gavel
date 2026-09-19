import Base
import ./prelude.bend as P

# ESCAPE PROBE (alternative algorithm, not a perturbation). The collection
# written as a walk that carries the position it is at, and pushes it onto an
# accumulator when the head matches. It is the plausible loop -- the one that
# does not need `inc_all` at all, because the index is the accumulator's own
# counter -- and it computes the same list the reference does at every input.
#
# Measured 2026-09-19 against the four-law set: **tier 3, three laws unproven --
# `positions_step`, `positions_hit`, `positions_miss`; only `positions_nil`
# proven.** It does not escape, and the reason is the shape of the law set rather
# than a mistake in the body: `positions_step` names *every* cons cell, so its
# left-hand side normalises to the reference's own unfolding, and a body that
# answers the same list by carrying the index instead has a different normal form
# at that point. The value of the probe is the negative reading -- there is no
# input position left free, because the step law is not restricted to a closed
# list and the two other laws name a hit and a miss at a variable list.
def Policy.snoc(xs: List<&2, Nat>, v: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      v <> Nil{}
    case +h <> +t:
      h <> Policy.snoc(t, v)

def Policy.pgo(+x: Nat, xs: List<&2, Nat>, +i: Nat, +acc: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      acc
    case +h <> +t:
      P.at_if(P.eq(h, x), Policy.pgo(x, t, i + 1n, Policy.snoc(acc, i)), Policy.pgo(x, t, i + 1n, acc))

def positions(+x: Nat, xs: List<&2, Nat>) -> List<&2, Nat>:
  Policy.pgo(x, xs, 0n, Nil{})
