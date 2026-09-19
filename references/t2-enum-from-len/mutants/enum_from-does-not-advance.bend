import Base
import ./prelude.bend as P

# `enum_from` repeats its start instead of advancing it.
#
# The step recurses with `a` rather than `1n + a`, so the run is `n` copies of
# the start. It type-checks -- the recursion is still on the count -- and it is
# the body the step law has to refuse: `enum_from_succ` names `1n + a` on its
# right and this body answers the old start there.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `enum_from_succ`, `enum_from_len`.
def enum_from(n: Nat, +a: Nat) -> List<Nat>:
  match n:
    case 0n:
      Nil{}
    case 1n+j:
      a <> enum_from(j, a)
