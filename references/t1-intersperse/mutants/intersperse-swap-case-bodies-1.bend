import Base
import ./prelude.bend as P

# The reference solution: the outer match finds the first element and the inner
# match finds the second, which is what tells the one-element list from a longer
# one. The separator is reusable because the step emits it and then hands it to
# the recursive call.
def intersperse(xs: List<&2, Nat>, +sep: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      match t:
        case Nil{}:
          h <> Nil{}
        case h2 <> t2:
          h <> (sep <> intersperse(t, sep))

    case h <> t:
      Nil{}
