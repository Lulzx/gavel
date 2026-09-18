import Base
import ./prelude.bend as P

# Returns the argument itself on a successor: the recursive call is dropped and
# only the last term is counted. It type-checks and the base case is intact, so
# `sum_to_zero` holds and `sum_to_succ` is the pin that fails, wanting
# `S.sum_to(p) + (1n + p)` and getting `1n + p`. The work law's helper fails
# against it too.
def sum_to(n: Nat) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+p:
      1n + p
