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
# that zipping a list with itself is this.
def double_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      # `h` is a Lone binder, so `(h + h)` is a linearity error -- not a
      # cosmetic one: the prelude is imported by the task, so it is checked
      # whether or not any law calls it, and every book in the task died at
      # "expected : h / observed : h (consumed more than once)" with a Location
      # inside this file. The task could not exceed tier 2 as pinned.
      +h2 = h
      (h2 + h2) <> double_all(t)
