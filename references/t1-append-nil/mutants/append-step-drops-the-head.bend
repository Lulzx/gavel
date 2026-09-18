import Base

# Wrong: the cons step recurses without consing the head back. `append_cons`
# rules it out directly (`append(x <> xs, ys)` must keep `x`) and `append_nil`
# sees the result come back one element short.
def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      append(t, ys)
