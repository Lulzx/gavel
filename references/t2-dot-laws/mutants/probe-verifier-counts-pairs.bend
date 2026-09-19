import Base
import ./prelude.bend as P

# PROBE. Satisfies the two nil anchors and differs only in the step: it adds
# `1n` per position instead of the product of the two heads. A reading of the
# walk is forced by `dot_cons` only if that law fixes the step term, so a
# reading here would be a hole.
def dot(xs: List<Nat>, ys: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      match ys:
        case Nil{}:
          0n
        case k <> u:
          1n + dot(t, u)
