import Base
import ./prelude.bend as P

# TODO(policy): pair the elements of `xs` and `ys` in order, and stop as soon as
# either list runs out. The result is a list of the prelude's pairs, built with
# `P.Mk{a, b}`; the two lists are consumed together, so a cons on one side pairs
# with a cons on the other and either side running out ends the result.
def zip(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, P.P2>:
  ?TODO
