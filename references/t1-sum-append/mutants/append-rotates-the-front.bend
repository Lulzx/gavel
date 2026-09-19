import Base

# Wrong: the cons step recurses on the tail of the first list but pushes the
# head onto the *second* one, so the answer is `reverse(xs) <> ys` --
# `append([1n, 2n], [3n])` is `[2n, 1n, 3n]`. Every element survives and the
# order within each list survives, so `sum` cannot tell the difference:
# `sum(reverse(xs)) == sum(xs)` makes both laws' sides equal, and the set as it
# stood before the order laws had nothing that mentioned `append` except under
# a `sum`. `append_cons` is the law that rules it out -- `1n <> append([2n],
# [3n])` is `[1n, 2n, 3n]` while `append([1n, 2n], [3n])` is `[2n, 1n, 3n]`.
def sum(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      h + sum(t)

def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      append(t, h <> ys)
