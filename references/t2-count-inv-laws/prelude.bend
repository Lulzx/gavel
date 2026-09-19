import Base

# Immutable, and owned by the task rather than the policy. `count_inv` is what
# the policy implements; everything here is the vocabulary the laws are stated
# in -- the strict comparison, the count of the elements below a value, and the
# constant list the last law is about.

# `is_lt(a, b)` is `1n` when `a` is strictly less than `b` and `0n` otherwise,
# by structural descent on both. It returns a `Nat` rather than a `Bool` because
# `count_gt` adds these up, and it is what keeps `count_gt` branch-free: a
# `match` may not scrutinise the result of a call.
def is_lt(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      match b:
        case 0n:
          0n
        case 1n+q:
          1n
    case 1n+p:
      match b:
        case 0n:
          0n
        case 1n+q:
          is_lt(p, q)

# `count_gt(x, ys)` is the number of elements of `ys` strictly below `x`. It
# steps on the list, so the count of a cons cell is the head's contribution plus
# the count of the tail. `x` is marked `+` because it is read once per element.
def count_gt(+x: Nat, ys: List<&2, Nat>) -> Nat:
  match ys:
    case Nil{}:
      0n
    case k <> u:
      is_lt(k, x) + count_gt(x, u)

# `replicate(n, x)` is the list of `n` copies of `x`, stepping on its count so
# the run grows on the right. Both arguments are read more than once -- the
# element is the head and the argument to the recursion, and the count is
# matched and decremented -- so both are marked `+`.
def replicate(n: Nat, +x: Nat) -> List<&2, Nat>:
  match n:
    case 0n:
      Nil{}
    case 1n+k:
      x <> replicate(k, x)
