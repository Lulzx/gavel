import Base
import ./prelude.bend as P

# The cons case forgets to put the head back, so the cap answers `Nil{}` for
# every list. Rejected by `min_all_single`: the left-hand side reduces to
# `P.min_all(Nil{}, n)`, which is `Nil{}`, where the law wants
# `P.min(h, n) <> Nil{}`. `min_all_append` is true of this body as a statement,
# since a function that answers `Nil{}` everywhere caps a concatenation to
# `Nil{}` either way; the checker stops at the base law.
def min_all(xs: List<Nat>, n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      min_all(t, n)
