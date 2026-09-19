import Base

# Immutable, and owned by the task rather than the policy. `zip_with` is what
# the policy implements; `max` is the operation it combines a pair of elements
# with, and `len` and `min` are here because the count law is stated in terms of
# them.

# The operation one pair of elements is combined with. It steps one successor
# off both of its arguments at once, so it is stuck on a variable -- `max(x, x)`
# is a fact about `x` rather than an unfolding -- and it is idempotent, which is
# what the diagonal law below reads off it.
def max(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+ap:
      match b:
        case 0n:
          1n + ap
        case 1n+bp:
          1n + max(ap, bp)

def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

# The smaller of two counts, stepping on the first and then on the second. A
# combined pair of lists is as long as the shorter of them, and this is the
# function that says which one that was.
def min(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      match b:
        case 0n:
          0n
        case 1n+q:
          1n + min(p, q)
