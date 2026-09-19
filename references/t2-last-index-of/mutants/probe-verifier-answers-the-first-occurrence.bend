import Base
import ./prelude.bend as P

# PROBE. This is the *mirror* function: the empty list answers `0n`, the walk
# steps the position on by one on a miss, and the head's own comparison decides
# the answer as soon as the head matches -- the position of the *first*
# occurrence, which is `index_of` and not `last_index_of`. Everything else about
# it is the reference's: the sentinel is the length, the head is compared, and
# the positions count from `0n`.
#
# The tail is read once, in the recursive call, so it needs no reusable mark; the
# target is read twice, so it keeps the signature's `+k`.
#
# Measured against this task's law set: tier 3, failing `last_index_of_step`,
# `last_index_of_miss`, `last_index_of_hit` and `last_index_of_last_wins`. Every
# law that reads a position separates it, and the two the pin leaves the step to
# -- `last_index_of_nil`, whose answer it keeps -- are the only ones that do not.
def last_index_of(xs: List<&2, Nat>, +k: Nat) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      P.at_if(P.eq(h, k), 0n, 1n + last_index_of(t, k))
