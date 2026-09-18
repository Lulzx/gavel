import Base

# Answers `True{}` for the empty list instead of `False{}`. The recursive branch
# is the reference's, so `any_cons` holds and every nonempty list is answered
# exactly as the reference answers it; `any_nil` is the law that fixes the bottom
# of the search, and it rejects `True{}` against `False{}`.
def any(xs: List<&2, Bool>) -> Bool:
  match xs:
    case Nil{}:
      True{}
    case h <> t:
      Bool.or(h, any(t))
