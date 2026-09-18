import Base

# Wrong: appending to the empty list answers the empty list instead of the
# other list. `append_nil_left` is the closed anchor that rules it out --
# `append(Nil{}, ys)` reduces, and what it must equal is the variable `ys`.
def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      h <> append(t, ys)
