import Base

# The cons case of `append` keeps the first list and forgets `ys` entirely, so
# the second piece is lost whenever the first one is non-empty. `sum_append`
# rejects it: at `xs = 1n <> Nil{}` and `ys = 2n <> Nil{}` the law's left-hand
# side is `1n + 0n` where its right-hand side is `(1n + 0n) + (2n + 0n)`.
# `sum_single` holds, since `append` is not reached at a one-element list.
def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      h <> append(t, ys)

def sum(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      h + sum(t)
