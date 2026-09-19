import Base

# Immutable, and owned by the task rather than the policy. `best_gain` is what
# the policy implements; this is the vocabulary the laws are stated in -- the
# largest rise from a value into a list.

# `max_sub(h, ys)` is the largest rise from `h` to an element of `ys`, floored
# at zero: the maximum of `y - h` over the elements `y` of `ys`, where the
# subtraction is truncated so that a descent contributes nothing. It steps on
# the list, so the answer for a cons cell is the head's own rise against the
# best of the tail's. `h` is read once per element, so it is marked `+`.
def max_sub(+h: Nat, ys: List<&2, Nat>) -> Nat:
  match ys:
    case Nil{}:
      0n
    case k <> +u:
      Nat.max(Nat.sub(k, h), max_sub(h, u))
