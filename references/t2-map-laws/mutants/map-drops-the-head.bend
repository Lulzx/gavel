import Base

# The cons case forgets to put the head back, so the map answers `Nil{}` for
# every list. Rejected by `map_cons` as a statement -- the left-hand side
# reduces to `map(t)`, which at `Nil{}` is `Nil{}`, where the law wants
# `(1n+h) <> map(t)` -- and by `len_map_cons`, also as a statement: the image is
# shorter than the list, so `len(map(h <> t))` is `len(t)` where the law wants
# `1n + len(t)`. The checker stops inside the helper `Policy.len_map` the first
# law is proved with, whose cons case asks for `1n + len(map(t))` and finds
# `1n + len(t)`.
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
      map(t)
