import Base
import ./prelude.bend as P

# `last_index_of` walks the list and steps past every element without ever
# consulting the head: the answer is the sentinel whenever the target occurs
# nowhere, and the tail's answer stepped on by one whenever it occurs somewhere,
# so the recorded position is never the head's own `0n`.
#
# This file exists for the law no generated mutant fails, or fails only by not
# type-checking: `last_index_of_hit` is about a head that is the target with
# nothing behind it, and that is the base of the walk rather than a step -- every
# generated rewrite moves a step. The tail is read twice, so it is declared
# reusably (`+t`); the head is never read at all, which a case binder allows.
#
# Measured against this task's law set: tier 3, failing `last_index_of_step`, `last_index_of_hit`
# and `last_index_of_last_wins`. The miss law survives it: counting one per
# element from `0n` on a list in which nothing is `0n` is the length, which is
# what that law asks for.
def last_index_of(xs: List<&2, Nat>, +k: Nat) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> +t:
      P.at_if(P.has_k(t, k), 1n + last_index_of(t, k), 1n + last_index_of(t, k))
