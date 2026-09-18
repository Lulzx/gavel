import Base
import ./prelude.bend as P

# The nested `match` is right and the outer head is never consed back on, so the
# recursion walks off the front of the list. `init_single` holds: at `h <> Nil{}`
# the inner match sees the empty tail and answers `Nil{}`. Rejected by
# `init_snoc`, at that same inner branch reached from the cons step of the
# induction -- the input `h <> (x <> Nil{})` takes the inner cons case, and the
# body answers `P.init(x <> Nil{})`, which is `Nil{}`, where the law wants
# `h <> Nil{}`.
def init(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      match t:
        case Nil{}:
          Nil{}
        case h2 <> t2:
          init(h2 <> t2)
