import Base
import ./prelude.bend as P

# `init` written as the tail: everything after the first element, rather than
# everything before the last, which is the pair of functions a person mixes up
# when the two are asked for in the same breath. `init_single` holds -- the tail
# of `h <> Nil{}` is `Nil{}`, which is what the law wants -- so it is
# `init_snoc` that rejects this body, at the cons step: the law's left-hand side
# reduces to `append(t, x <> Nil{})` where its right-hand side is `h <> t`.
def init(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      t
