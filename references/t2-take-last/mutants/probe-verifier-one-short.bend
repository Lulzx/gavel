import Base
import ./prelude.bend as P

# ESCAPE PROBE, written by the verifier rather than the author. The boundary read
# as *strictly* shorter rather than "no longer than": the walk here drops the
# head while the length is at least the count, so a list whose length is exactly
# `k` loses its front and every list comes back one element short of what was
# asked for. It agrees with the reference on every list longer than `k` and on
# every list shorter than `k`, which is why the closed laws and the law about a
# count past the end do not separate it, and it is the reading of "fewer than `k`
# elements" that drops the boundary from the wrong side.
#
# It is not a shape the generated corpus reaches: those rewrite a call's
# arguments, swap a case's body or drop a case, and this body rewrites *which*
# comparison the step is decided by.
#
# Measured 2026-09-19, same command as the hand mutant: **tier 3**,
# `laws_failed = ["take_last_step", "take_last_single", "take_last_long",
# "take_last_three"]`. Four laws catch it, and the step law is the first: the
# body's comparison is `P.le(2n+len(t), k)` where the law names
# `P.le(1n+len(t), k)`, so the boundary is a shape rejection and not a lucky
# closed list. `take_last_nil`, `take_last_zero` and `take_last_all` do not
# separate it, which is exactly the agreement described above. The set is sound
# against it, so there is no hole.
def take_last(xs: List<&2, Nat>, +k: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> +t:
      P.keep_if(P.le(1n + P.len(h <> t), k), h <> t, take_last(t, k))
