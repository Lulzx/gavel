import Base

# Immutable, and owned by the task rather than the policy. The parity test and
# the halving are what one step of the power-of-two test is made of, and they
# are supplied here for a reason about the checker rather than for convenience:
# a `match` cannot scrutinise a computed value. The policy's recursion has to
# consume a structural argument, so it consumes the width and carries the number
# along; the test itself is therefore a *term* built out of these, not a match
# on `n`. Both match on `n` one constructor at a time, so with a variable they
# are stuck -- which is what keeps the step law definitional.

# Is `n` even? Two at a time, so a variable number is stuck.
def is_even_b(n: Nat) -> Bool:
  match n:
    case 0n:
      True{}
    case 1n+p:
      match p:
        case 0n:
          False{}
        case 1n+q:
          is_even_b(q)

# `n` divided by two, rounding down.
def half(n: Nat) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+0n:
      0n
    case 1n+1n+p:
      1n + half(p)
