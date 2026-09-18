import Base

# Immutable, and owned by the task rather than the policy: the second law is
# stated in terms of `len` and `max_list`, so the policy's `max_prefix` may lean
# on these. All three match on their first argument, which is what makes that
# law's left-hand side stuck for a variable `xs`.
def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

def max(a: Nat, b: Nat) -> Nat:
  match a b:
    case 0n 0n:
      0n
    case 0n 1n+bp:
      1n + bp
    case 1n+ap 0n:
      1n + ap
    case 1n+ap 1n+bp:
      1n + max(ap, bp)

def max_list(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      max(h, max_list(t))
