import Base

# Immutable, and owned by the task rather than the policy. `cum_max` and
# `max_all` are what the policy implements; `len` is what the length law is
# stated with.

# The number of elements in a list. It walks the whole list, so on a variable it
# is stuck, and `len(x <> xs)` is `1n + len(xs)` however long `xs` is.
def len(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)
