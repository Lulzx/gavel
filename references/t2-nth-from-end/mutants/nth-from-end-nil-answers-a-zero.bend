import Base
import ./prelude.bend as P

# The walk answers `0n` when the list runs out instead of the default it was
# handed, so a distance past the end reads as a position rather than as an
# absence. Every other input is untouched: this arm is the one the walk takes
# when it has passed the front of the list.
#
# This file exists for a law that no generated mutant fails: `nth_from_end_nil`'s
# left-hand side is the constructor `Nil{}` with variables beside it, so the
# generator -- whose mutants rewrite a step, swap case bodies or permute arguments
# -- never states one that changes only this arm. This is the reference with the
# empty arm given a different answer, so it type-checks and every recursive call
# is untouched.
#
# Measured against this task's law set: tier 3, failing `nth_from_end_nil` and
# `nth_from_end_out`.
def nth_from_end(xs: List<&2, Nat>, +k: Nat, +d: Nat) -> Nat:
  match xs:
    case Nil{}:
      0n
    case +h <> +t:
      P.pick_if(P.eq(P.len(t), k), h, nth_from_end(t, k, d))
