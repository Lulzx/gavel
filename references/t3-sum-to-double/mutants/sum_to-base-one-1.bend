import Base
import ./prelude.bend as P

# The recursion is the reference's and the base case answers one instead of
# zero, which is the classic off-by-one. The recursive branch is untouched, so
# `sum_to_succ` holds, and `sum_to_zero` is the pin that fixes the bottom of the
# recursion: it rejects `1n` against `0n`. The work law fails against it too,
# since the doubling is stated for every `n` and this body is wrong at `0n`.
def sum_to(n: Nat) -> Nat:
  match n:
    case 0n:
      1n
    case 1n+p:
      +p = p
      sum_to(p) + (1n + p)
