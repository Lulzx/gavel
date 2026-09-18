import Base

def any(xs: List<&2, Bool>) -> Bool:
  match xs:
    case Nil{}:
      False{}
    case h <> t:
      Bool.or(h, any(t))
