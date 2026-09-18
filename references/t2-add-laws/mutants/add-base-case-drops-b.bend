import Base

# A body a person would plausibly write: the base case answers `0n` instead of
# the second argument, as if addition only ever added the first summand.
# Rejected by `add_succ`: `add(0n, 1n+y)` is `0n` on the left and
# `1n + add(0n, y)` on the right, and the body's own base makes that `1n`.
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      1n + add(p, b)
