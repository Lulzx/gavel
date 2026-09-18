import Base

# Wrong: the cons step puts the head onto the second list and then recurses,
# which rotates the first list into the second rather than appending it.
# `append_nil` sees the order come back wrong (`append([a, b], Nil{})` is
# `[b, a]`) and `append_assoc` sees it too.
def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      append(t, h <> ys)
