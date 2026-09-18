import Base

# Immutable, and owned by the task rather than the policy: the second law is
# stated in terms of `len` and `count_odd`, so the policy's `count_odd_prefix`
# may lean on these. All three match on their first argument, which is what
# makes that law's left-hand side stuck for a variable `xs`. `is_odd` is
# `Nat`-valued rather than `Bool`, so the law's right-hand side is an
# arithmetic term.
def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

def is_odd(n: Nat) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+0n:
      1n
    case 1n+1n+p:
      is_odd(p)

def count_odd(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      is_odd(h) + count_odd(t)
