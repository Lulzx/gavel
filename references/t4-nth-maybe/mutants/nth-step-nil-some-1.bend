import Base
import ./prelude.bend as P

# Only the far end of the empty case is wrong: `Nil{}` at `0n` is the
# reference's `None{}`, and `Nil{}` at `1n + p` answers `Some{0n}`. Every other
# branch is the reference, so both value laws hold and so does `nth_some`. The
# out-of-range law catches it at any positive index: `P.len(Nil{})` is `0n`, so
# the premise holds and `None{}` is what the answer has to be.
def nth(k: Nat, xs: List<&2, Nat>) -> Maybe<&2, Nat>:
  match k:
    case 0n:
      match xs:
        case Nil{}:
          None{}
        case h <> t:
          Some{h}
    case 1n+p:
      match xs:
        case Nil{}:
          Some{0n}
        case h <> t:
          nth(p, t)
