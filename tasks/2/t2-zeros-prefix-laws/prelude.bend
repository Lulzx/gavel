import Base

# Immutable, and owned by the task rather than the policy: the second law is
# stated in terms of `len` and `count_zeros`, so the policy's `zeros_prefix` may
# lean on these. Both match on their first argument, which is what makes that
# law's left-hand side stuck for a variable `xs`.
def is_zero(n: Nat) -> Nat:
  match n:
    case 0n:
      1n
    case 1n+p:
      0n

def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

def count_zeros(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      is_zero(h) + count_zeros(t)
