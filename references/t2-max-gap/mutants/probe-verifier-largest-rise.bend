import Base
import ./prelude.bend as P

# ESCAPE PROBE, written by the verifier rather than the author. The walk with
# its distance read as a *rise*: `Nat.sub(h, prev)` is how much the list went up
# at that window, and a descent contributes nothing. Read as a specification,
# this is "the largest gap" as the largest step upwards -- the reading a task
# named for the largest difference invites, and the one that would make this the
# bank's `best_gain` under another name. The absolute distance is the whole of
# what separates them.
#
# It is not a shape the generated corpus reaches: those rewrite a call's
# arguments or an answer, and this body replaces the comparison the step is
# folded with.
#
# Measured 2026-09-19, same command as the hand mutants: **tier 3**,
# `laws_failed = ["gap_go_cons", "gap_go_same"]`. Two laws catch it and neither
# is a shape rejection: the step law because the body's step is not the one the
# law names, and the induction because the base case of the mutant's `Nat.sub`
# walk is not `P.absdiff`. The set is sound against it, so there is no hole.
def gap_go(xs: List<&2, Nat>, +prev: Nat, best: Nat) -> Nat:
  match xs:
    case Nil{}:
      best
    case +h <> t:
      gap_go(t, h, Nat.max(Nat.sub(h, prev), best))

def max_gap(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      gap_go(t, h, 0n)
