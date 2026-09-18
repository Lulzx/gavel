import Base
import ./prelude.bend as P

# The reference solution: the indicator of the head added to the count of the
# tail, so the answer is a sum of `0n`s and `1n`s rather than a running
# comparison. `x` is `+` because it is used in the indicator and again in the
# recursion.
def count(+x: Nat, xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      0n
