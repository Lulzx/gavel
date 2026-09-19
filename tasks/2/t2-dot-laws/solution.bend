import Base
import ./prelude.bend as P

# TODO(policy): implement. Recurse on `xs`. The empty list has nothing to pair
# and answers `0n`; a cons cell looks at `ys` and answers `0n` there too when
# `ys` has run out, and otherwise multiplies the two heads and adds the walk
# over the two tails.
def dot(xs: List<Nat>, ys: List<Nat>) -> Nat:
  ?TODO
