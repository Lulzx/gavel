import Base
import ./prelude.bend as P

# The cons case forgets to put the head back, so the map answers `Nil{}` for
# every list -- the recursion is there and its result is the whole answer.
# Rejected by `dec2_all_single`, whose left-hand side reduces to
# `P.dec2_all(Nil{})`, which is `Nil{}`, where the law wants
# `P.dec2(h) <> Nil{}`. `dec2_all_append` is true of this body as a statement,
# since a function that answers `Nil{}` everywhere maps a concatenation to
# `Nil{}` either way; the reference proof fails there anyway, because its step
# rewrites under the motive `P.dec2(h) <> _`, which the goal does not have once
# the head is dropped.
def dec2_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      dec2_all(t)
