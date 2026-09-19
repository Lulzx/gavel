import Base

# Immutable, and owned by the task rather than the policy. The halving is what
# one step of the walk is made of, and it is supplied here for a reason about
# the checker rather than for convenience: a `match` cannot scrutinise a
# computed value, and the policy's recursion has to consume a structural
# argument -- so it consumes the width and carries the number along, which makes
# the halving a *term* the walk is started on rather than a match. It takes the
# number apart two at a time, so with a variable it is stuck, which is what
# keeps the step law definitional.

# `n` divided by two, rounding down.
def half(n: Nat) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+0n:
      0n
    case 1n+1n+p:
      1n + half(p)
