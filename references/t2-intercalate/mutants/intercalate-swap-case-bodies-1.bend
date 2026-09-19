import Base
import ./prelude.bend as P

# The reference solution: the outer match finds the first list and the inner
# match finds the second, which is what tells the one-element collection from a
# longer one. The step puts the separator between the first list and the joining
# of the rest, which is a concatenation of three pieces -- so the answer is
# written with `P.append`. The separator is reusable because the step emits it
# and then hands it to the recursive call.
def intercalate(+sep: List<&2, Nat>, xss: List<&2, List<&2, Nat>>) -> List<&2, Nat>:
  match xss:
    case Nil{}:
      match t:
        case Nil{}:
          h
        case h2 <> t2:
          P.append(h, P.append(sep, intercalate(sep, h2 <> t2)))

    case h <> t:
      Nil{}
