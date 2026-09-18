import Base

# Immutable, and owned by the task rather than the policy. The laws are stated
# in terms of truncated subtraction, which the policy's function is built from,
# so it lives here and `absdiff` is the only thing under test.

# `sub` steps on both arguments at once, so with either side a variable the goal
# does not reduce: only the two zero cases below compute on their own, and that
# is what leaves the work to the inductions rather than to the unfolding.
def sub(a: Nat, b: Nat) -> Nat:
  match a b:
    case 0n 0n:
      0n
    case 0n 1n+bp:
      0n
    case 1n+ap 0n:
      1n+ap
    case 1n+ap 1n+bp:
      sub(ap, bp)
