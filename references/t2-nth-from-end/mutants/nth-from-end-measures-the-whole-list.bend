import Base
import ./prelude.bend as P

# The walk measures the *whole* list rather than the tail, so every head is
# compared against a length one greater than the number of elements after it and
# every distance lands one element too far back. Only the empty input is right.
#
# This file exists for `nth_from_end_out`, whose left-hand side is the closed
# list `[1n, 2n]` asked for `2n`: nothing the generator produces reaches a
# distance that is out of range on a closed list. It is the reference with one
# argument of the test changed -- `P.len(xs)` in place of `P.len(t)` -- so it
# type-checks and every recursive call is untouched.
#
# Measured against this task's law set: tier 3, failing `nth_from_end_step`,
# `nth_from_end_pair_last`, `nth_from_end_pair_first`, `nth_from_end_third`,
# `nth_from_end_last` and `nth_from_end_out`.
def nth_from_end(+xs: List<&2, Nat>, +k: Nat, +d: Nat) -> Nat:
  match xs:
    case Nil{}:
      d
    case +h <> +t:
      P.pick_if(P.eq(P.len(xs), k), h, nth_from_end(t, k, d))
