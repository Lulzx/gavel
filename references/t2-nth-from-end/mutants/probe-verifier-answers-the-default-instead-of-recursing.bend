import Base
import ./prelude.bend as P

# An independently invented plausible-but-wrong body: the walk answers the
# default as soon as the head is not the element at the distance asked for,
# instead of recursing. It is a reading of "the element `k` positions from the
# end, or the default" in which the default is what a *miss* means rather than
# what running off the front means -- so `[1n, 2n, 3n]` asked for `1n` answers the
# default where the reference answers `2n`, while a list whose head is already at
# the distance asked for is answered correctly. The laws whose distance is
# decided by literals at the head (`pair_first`, `third`, `out`) are still
# proved; the definitional step and the two laws with a run of unknown length
# catch it.
#
# Measured against this task's law set: tier 3, failing `nth_from_end_step`,
# `nth_from_end_pair_last` and `nth_from_end_last`. Tier 4 would mean the law set
# admits a wrong body; it does not.
def nth_from_end(xs: List<&2, Nat>, +k: Nat, +d: Nat) -> Nat:
  match xs:
    case Nil{}:
      d
    case +h <> +t:
      P.pick_if(P.eq(P.len(t), k), h, d)
