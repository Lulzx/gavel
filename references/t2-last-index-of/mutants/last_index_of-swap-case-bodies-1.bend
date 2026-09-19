import Base
import ./prelude.bend as P

# The reference solution: step on the list, but answer from the tail's side,
# because the *last* occurrence is the one wanted. `P.has_k(t, k)` says whether
# the target still occurs in the tail: when it does, the head's own occurrence
# is not the last one, and the answer is the tail's answer stepped on by one.
# When it does not, the head is the last chance -- `0n` when the head is the
# target, and otherwise the sentinel, which is the tail's answer stepped on by
# one; the tail's answer there is the empty list's `0n` counted up once per
# element, so that is the length of the list.
#
# The tail is read twice in the step, once into the walk and once into the
# recursive call, so it is declared reusably (`+t`); the target is read three
# times, so it is declared reusably as well (`+k`).
def last_index_of(xs: List<&2, Nat>, +k: Nat) -> Nat:
  match xs:
    case Nil{}:
      P.at_if(P.has_k(t, k), 1n + last_index_of(t, k), P.at_if(P.eq(h, k), 0n, 1n + last_index_of(t, k)))

    case h <> +t:
      0n
