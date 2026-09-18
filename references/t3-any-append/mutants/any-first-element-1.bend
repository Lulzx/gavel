import Base

# Answers the first element and stops: a list is true when its head is true,
# whatever follows. The base case is the reference's, so `any_nil` holds, and
# `any_cons` rejects it -- the law's right side is `Bool.or(h, S.any(t))` and
# this computes to `h`, which `Bool.or` does not reduce to while `S.any(t)` is a
# variable.
def any(xs: List<&2, Bool>) -> Bool:
  match xs:
    case Nil{}:
      False{}
    case h <> t:
      h
