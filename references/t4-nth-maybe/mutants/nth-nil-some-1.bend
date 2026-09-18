import Base
import ./prelude.bend as P

# The empty list answers `Some{0n}` at every index and everything else is the
# reference. Both value laws hold -- they only quantify over cons lists -- and
# `nth_some` holds too, since `Some{}` is the answer the positive law asks for.
# It is `nth_none` alone that rejects it, and that is the point of the pair: on
# `Nil{}` the out-of-range premise reduces to `{False{} == False{}}`, which
# holds, so the law is not vacuous there and `None{}` is required of every index.
def nth(k: Nat, xs: List<&2, Nat>) -> Maybe<&2, Nat>:
  match k:
    case 0n:
      match xs:
        case Nil{}:
          Some{0n}
        case h <> t:
          Some{h}
    case 1n+p:
      match xs:
        case Nil{}:
          Some{0n}
        case h <> t:
          nth(p, t)
