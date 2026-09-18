import Base

# Folds the head in with `and` where the task asks for `or`: a list is true only
# when every element is. It is the plausible slip of the pair, it type-checks,
# and the base case is the one the two agree on, so `any_nil` holds. `any_cons`
# is the law that separates them -- `Bool.and(h, S.any(t))` is not
# `Bool.or(h, S.any(t))` while the second argument is a variable.
def any(xs: List<&2, Bool>) -> Bool:
  match xs:
    case Nil{}:
      False{}
    case h <> t:
      Bool.and(h, any(t))
