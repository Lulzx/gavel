import Base

# Immutable, and owned by the task rather than the policy. `pad` is what the
# policy implements; `len` and `max` are here because the law about the length
# is stated in terms of them.

def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

# The larger of two counts, stepping on the first and then on the second, in
# the order a pad runs out of target length and of list.
def max(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      match b:
        case 0n:
          1n + p
        case 1n+q:
          1n + max(p, q)
