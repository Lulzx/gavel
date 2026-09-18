import Base

# Wrong: keeps the head of every cell, so it appends the new element but loses
# the rest. The same answer as `h <> snoc(Nil{}, x)`; written this way because
# the checker reads the arguments of a self-call left to right and refuses one
# whose list argument is a constant rather than a shrinking tail, so the
# recursive spelling did not type-check on its own and no law ever saw it.
def snoc(xs: List<Nat>, x: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      x <> Nil{}
    case h <> t:
      h <> x <> Nil{}
