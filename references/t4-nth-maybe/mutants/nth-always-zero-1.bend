import Base
import ./prelude.bend as P

# Every non-empty list answers `Some{0n}` at every index: in range, because
# `Some{}` is the right branch, and the recursion is the reference's, so the
# step law and both domain laws hold. What it never does is read the list. The
# answer is an element of the list for no `h` but `0n`, and `nth_zero` is the
# law that says the answer is *this* cons's head -- universally quantified over
# `h`, so a single counterexample refutes it.
def nth(k: Nat, xs: List<&2, Nat>) -> Maybe<&2, Nat>:
  match k:
    case 0n:
      match xs:
        case Nil{}:
          None{}
        case h <> t:
          Some{0n}
    case 1n+p:
      match xs:
        case Nil{}:
          None{}
        case h <> t:
          Some{0n}
