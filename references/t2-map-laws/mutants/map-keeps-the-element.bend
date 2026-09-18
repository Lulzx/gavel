import Base

# The head is consed on unchanged: the recursion is right and the successor is
# never applied, which is a plausible slip for a map whose function is named
# separately. Rejected by `map_cons`, whose left-hand side reduces to
# `h <> map(t)` where its right-hand side is `(1n+h) <> map(t)` -- the variable
# `h` against the stuck `1n+h`. `len_map_cons` and the helper it is proved with
# are untouched, since replacing an element with an element leaves the length
# alone: the law that names the function is the one that rejects this body.
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
      h <> map(t)
