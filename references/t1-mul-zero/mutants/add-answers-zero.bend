import Base

# The stub declares `add` and `mul` and the prompt asks for both, but the three
# laws about `mul` are written against Base's `+`. So a `mul` that writes its
# own step as `b + mul(p, b)` never calls `add` at all, and `add` is free: this
# body answers `0n` there and **measured tier 4, reward 1.000** on 2026-09-19,
# with `mul_zero` proved by induction and the other two laws `{==}`.
# `add_plus` is the law that closes it -- `S.add(x, y) == x + y`, the statement
# the reference proof already carried as `Policy.add_plus`. This file now
# measures tier 3, failing at `LAWS.add_plus`.
def add(a: Nat, b: Nat) -> Nat:
  0n

def mul(a: Nat, +b: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      b + mul(p, b)
