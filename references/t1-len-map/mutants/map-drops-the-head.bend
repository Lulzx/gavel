import Base
import ./prelude.bend as P

# Wrong: `map` drops the head and keeps the tail, so it runs one element
# behind. `map_cons` rules it out -- the law keeps `inc(x)` at the front --
# and `len_map` sees the result come back one shorter.
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
