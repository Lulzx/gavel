import Base
import ./prelude.bend as P

# ESCAPE PROBE, written by the verifier rather than the author. The reference
# with the two values the step chooses between handed over the other way round:
# on a match it keeps the head it found and on a miss it puts the replacement
# there and walks on. Read as a specification, this is "replace the first cell
# that is *not* `k`" -- a plausible misreading of a problem whose two arguments
# are a value to find and a value to put down, and the one the name invites.
#
# It is deliberately not a shape the generated corpus reaches: `swap-args-5`
# exchanges the two arguments of the *comparison*, which is symmetric and leaves
# the step alone, where this one exchanges the answers the step chooses between.
#
# Measured 2026-09-19, same command as the hand mutants: **tier 3**,
# `laws_failed = ["replace_first_hit", "replace_first_miss",
# "replace_first_len", "replace_first_three", "replace_first_absent"]`. Five of
# the six laws catch it and none of them is a shape rejection: the set is sound
# against this body, so there is no hole here.
def replace_first(xs: List<&2, Nat>, +k: Nat, +y: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> +t:
      P.rp_branch(P.eq(h, k), y, h, t, replace_first(t, k, y))
