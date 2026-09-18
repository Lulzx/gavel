import Base

# The base case answered with a one-element list: a stray element where the map
# has none, so every image carries one extra element. The cons case is the
# reference's, so `map_cons` is true of this body, and it is `len_map_cons` that
# is false of it -- the image is longer than the list for every list. The
# checker stops inside the helper `Policy.len_map`, at its base case: it asks
# for `len(Nil{})` to equal `len(map(Nil{}))`, which is `0n` against `1n`.
def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

def map(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      1n <> Nil{}
    case h <> t:
      (1n+h) <> map(t)
