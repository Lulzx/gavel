import Base

# Immutable, and owned by the task rather than the policy. `count_runs` is what
# the policy implements; `is_eq` and `nsub` are here because the laws are stated
# in terms of them, and because the step of `count_runs` has to be branch-free.

# `nsub(a, b)` is `a - b` cut off at zero.
def nsub(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      match b:
        case 0n:
          a
        case 1n+q:
          nsub(p, q)

# `1n` when the two numbers are equal and `0n` otherwise, by structural descent
# on both. It returns a `Nat` rather than a `Bool` because the count adds these
# up, and it is what makes the step of `count_runs` branch-free: a `match` may
# not scrutinise the result of a call, so a body that answers one thing for a
# new run and nothing for a continuation cannot branch on a comparison. It adds
# the comparison instead.
def is_eq(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      match b:
        case 0n:
          1n
        case 1n+q:
          0n
    case 1n+p:
      match b:
        case 0n:
          0n
        case 1n+q:
          is_eq(p, q)
