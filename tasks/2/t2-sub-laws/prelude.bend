import Base

# Immutable, and owned by the task rather than the policy: the second law is
# stated in terms of `pred`, so the policy's `sub` may lean on it.
def pred(n: Nat) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+p:
      p
