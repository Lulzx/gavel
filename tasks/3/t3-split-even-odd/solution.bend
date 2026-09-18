import Base
import ./prelude.bend as P

# TODO(policy): `xs` split into the elements at even positions and the elements
# at odd positions, counting from zero. The head goes on the front of the odd
# half of the tail, and the even half of the whole is the odd half of the tail.
# The tail is used twice in that step -- once for each half -- so `xs` is `+`.
def split(+xs: List<&2, Nat>) -> P.PairL:
  ?TODO
