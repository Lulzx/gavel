import Base
import ./prelude.bend as P

# The identity body: the list is rebuilt from its own binders and nothing is
# dropped. Rejected by `init_single`, whose left-hand side reduces to
# `h <> Nil{}` where the law wants `Nil{}`, and by `init_snoc` as well: the body
# is the identity, so at the cons step the law's left-hand side is
# `append(h <> t, x <> Nil{})` where its right-hand side is `h <> t`.
def init(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      h <> t
