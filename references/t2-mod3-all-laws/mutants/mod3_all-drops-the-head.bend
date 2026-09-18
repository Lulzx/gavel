import Base
import ./prelude.bend as P

# The cons case forgets to put the head back, so the map answers `Nil{}` for
# every list. Rejected by `mod3_all_single`: the left-hand side reduces to
# `P.mod3_all(Nil{})`, which is `Nil{}`, where the law wants
# `P.mod3(h) <> Nil{}`. `mod3_all_append` is true of this body as a statement,
# since a function that answers `Nil{}` everywhere maps a concatenation to
# `Nil{}` either way; the checker stops at the base law.
def mod3_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      mod3_all(t)
