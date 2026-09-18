import Base
import ./prelude.bend as P

# A body called "absdiff" that adds instead of subtracting. It satisfies both
# zero laws -- `0n + b` is `b` and `a + 0n` is `a` -- so the two-sided part of
# the specification does not see it. `absdiff_self` does: `1n+p + 1n+p` is not
# `0n`. This is the mutant the self law exists for.
def absdiff(+a: Nat, +b: Nat) -> Nat:
  a + b
