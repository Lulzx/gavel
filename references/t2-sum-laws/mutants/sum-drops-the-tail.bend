import Base

# The head is added and the recursion is not: `sum` answers its first element,
# written as `h + 0n` rather than `h`. `sum_single` holds -- at `h <> Nil{}` the
# answer is exactly the `h + 0n` the law's step rewrites -- and `sum_append`
# rejects it: at `xs = 1n <> Nil{}` and `ys = 2n <> Nil{}` the law's left-hand
# side is `1n + 0n` where its right-hand side is `(1n + 0n) + (2n + 0n)`.
def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

def sum(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      h + 0n
