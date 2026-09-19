import Base
import ./prelude.bend as P

# `last_index_of` answers `1n` at the empty list instead of `0n`: the cons case is
# the reference's, and the empty list answers one rather than the zero that is
# its own length.
#
# This file exists for a law that no generated mutant fails. `last_index_of_nil`
# is the only law whose left-hand side is the ground `Nil{}`, so it is the one
# law a walk of the list never reaches: the generated `constant-body` mutant
# copies the empty case's answer into the cons case and leaves the empty case
# alone, so it satisfies the pin, and every other generated rewrite stops before
# the base case. The target is still read on every step and the cons case is the
# reference's, so the body type-checks.
#
# Measured against this task's law set: tier 3, failing `last_index_of_nil` and `last_index_of_miss`.
# The sentinel is the one the walk counts up to, so answering one at the empty
# list carries one extra step through every length on the way.
def last_index_of(xs: List<&2, Nat>, +k: Nat) -> Nat:
  match xs:
    case Nil{}:
      1n
    case h <> +t:
      P.at_if(P.has_k(t, k), 1n + last_index_of(t, k), P.at_if(P.eq(h, k), 0n, 1n + last_index_of(t, k)))
