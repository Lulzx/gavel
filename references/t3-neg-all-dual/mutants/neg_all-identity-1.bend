import Base
import ./prelude.bend as P

# A map that returns its argument: both folds agree with the duality laws on a
# list that has not been negated only when the list is constant, which is the
# whole reason those laws are not `{==}`.
def neg_all(xs: List<&2, Bool>) -> List<&2, Bool>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      h <> neg_all(t)
