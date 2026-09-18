import Base

# Wrong: the cons step keeps the head and the whole second list but drops the
# rest of the first. `sum_append` rules it out -- the sum of the result does
# not split into `sum(xs) + sum(ys)` -- and the sum law sees the tail go
# missing as well.
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
      h <> ys
