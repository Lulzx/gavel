import Base

# The cons case of `append` answers the recursion alone, so one element goes
# missing per step of the first list. `sum_append` rejects it: at
# `xs = 1n <> Nil{}` and `ys = 2n <> Nil{}` the law's left-hand side is `0n`
# where its right-hand side is `(1n + 0n) + (2n + 0n)`. `sum_single` holds, since
# `append` is not reached at a one-element list.
def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      append(t, ys)

def sum(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      h + sum(t)
