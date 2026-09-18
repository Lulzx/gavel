import Base

# The mapped head is consed onto the unmapped tail: a plausible slip when the
# recursion is written out of order, since the head gets its successor and the
# rest do not. Rejected by `map_cons` as a statement, whose left-hand side
# reduces to `(1n+h) <> t` where its right-hand side is `(1n+h) <> map(t)`.
# `len_map_cons` is true of this body -- one element in, one element out, so the
# lengths still agree -- and the checker stops anyway, inside the helper
# `Policy.len_map`, whose cons case looks for `1n + len(map(t))` in a goal that
# has `1n + len(t)` there.
def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

def map(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      (1n+h) <> t
