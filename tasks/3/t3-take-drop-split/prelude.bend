import Base

# Immutable, and owned by the task rather than the policy. `take` and `drop`
# are what the policy implements; `append`, `len` and `min` are here because
# the laws are stated in terms of them.

# `append` matches on its first argument, so `append(take(..), ..)` does not
# reduce until the left list is a cons.
def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

# The smaller of two counts, stepping on the first and then on the second. The
# second `case` is not decoration: `take` stops at whichever of the count and
# the list runs out first, and this is the function that says how many elements
# that leaves.
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
