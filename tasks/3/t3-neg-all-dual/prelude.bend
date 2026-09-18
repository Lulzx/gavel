import Base

# Immutable, and owned by the task rather than the policy. `any_bool` and
# `all_bool` are the vocabulary the laws are stated in -- the duality between
# them is what the policy writes. Both match on their first argument, so with a
# variable list neither reduces, and that is what leaves the laws about them to
# an induction rather than to an unfolding.

def any_bool(xs: List<&2, Bool>) -> Bool:
  match xs:
    case Nil{}:
      False{}
    case h <> t:
      Bool.or(h, any_bool(t))

def all_bool(xs: List<&2, Bool>) -> Bool:
  match xs:
    case Nil{}:
      True{}
    case h <> t:
      Bool.and(h, all_bool(t))
