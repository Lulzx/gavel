import Base
import ./prelude.bend as P

# The empty case answers `1n`: a body that reads the empty list as one
# occurrence, which is the off-by-one a policy lands on when it thinks of the
# recursion as "stop after the last element" rather than "there is nothing
# left". Every other case is the reference's, so the only law that can see it
# is the definitional base: `count_nil` wants `0n` at a variable `x`. Measured:
# the isolated runs prove `count_cons` and fail the base, so the `1n` is seen by
# `count_nil` alone.
def count(+x: Nat, xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      1n
    case h <> t:
      P.is_eq(x, h) + count(x, t)
