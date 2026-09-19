import Base

# `k` copies of one number, in a list: `rep(7n, 3n)` is `[7n, 7n, 7n]`, and `k`
# copies of nothing is the empty list. It is here because the answer repeats each
# element in place, so the copy of one element has to be built before the rest of
# the answer is put after it, and a `match` on the answer cannot produce a run of
# copies.
def rep(+x: Nat, k: Nat) -> List<&2, Nat>:
  match k:
    case 0n:
      Nil{}
    case 1n+kp:
      x <> rep(x, kp)

# `xs` followed by `ys`: `append([1n, 2n], [3n])` is `[1n, 2n, 3n]`. It is here
# because the answer to a non-empty list is the copies of its first element with
# the copies of the rest attached after them, and attaching one list to another
# is not something `<>` does -- `<>` puts a single element in front of a list.
def append(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)
