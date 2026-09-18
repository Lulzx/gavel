import Base

# Wrong: the cons step keeps the head and the whole second list but drops the
# rest of the first. `append_nil` rules it out -- `append([a, b], Nil{})` comes
# back `[a]` -- and `append_cons` sees the tail go missing.
def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> ys
