import Base

# Immutable, and owned by the task rather than the policy. `zip_sum` is what
# the policy implements; `len`, `min` and `double_all` are here because the
# laws are stated in terms of them.

def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

# The smaller of two counts, stepping on the first and then on the second. A
# zipped pair of lists is as long as the shorter of them, and this is the
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

# Elementwise doubling, fixed here rather than asked for: the last law says
# that zipping a list with itself is this. The head is used twice, so the case
# is written `case +h <> t:`, which is the pattern form of a `+` parameter.
def double_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> t:
      (h + h) <> double_all(t)
