import Base
import ./prelude.bend as P

# ESCAPE PROBE, written by the verifier rather than the author. The answer read
# as "the suffix, raised by the head" with the head itself left out: every cell
# that follows is right and the answer is one cell short, so it is wrong about
# the length and about the first entry at once. It agrees with the reference on
# every list it was not asked about -- there are none -- and it is the reading of
# the step that takes the head to be only a *raise*, forgetting that the head is
# also the first thing seen.
#
# It is not a shape the generated corpus reaches: those rewrite a call's
# arguments, swap a case's body, drop a case or move a recursion onto a
# parameter, and this body drops the head from the answer the step builds.
#
# Measured 2026-09-19, same command as the hand mutant: **tier 3**,
# `laws_failed = ["cum_max_single", "cum_max_cons", "cum_max_len",
# "cum_max_three"]`. Four laws catch it -- the singleton, the step, the length
# and the closed list -- and the length law is the one that says the answer is
# one entry per element rather than one per element the walk changed. The set is
# sound against it, so there is no hole.
def max_all(ys: List<&2, Nat>, +m: Nat) -> List<&2, Nat>:
  match ys:
    case Nil{}:
      Nil{}
    case h <> t:
      Nat.max(h, m) <> max_all(t, m)

def cum_max(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> t:
      max_all(cum_max(t), h)
