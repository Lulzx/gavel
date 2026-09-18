import Base

# Searches the tail and never folds the head in: the first element of a list is
# invisible to it. It type-checks, the base case is intact so `any_nil` holds,
# and the step law is the one that sees it -- `any_cons` is stated with `h` a
# *variable* of type `Bool`, so both values of the head have to come out right
# and neither does. The append law's proof fails against it as well, and that one
# is worth reading twice: dropping every head makes this body answer `False{}`
# everywhere, so the law is *true* of it and the induction cannot see that.
def any(xs: List<&2, Bool>) -> Bool:
  match xs:
    case Nil{}:
      False{}
    case h <> t:
      any(t)
