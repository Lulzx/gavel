import Base
import ./prelude.bend as P

# TODO(policy): implement. Walk both lists at once: the empty list on either
# side ends the walk at `0n`, and two cons cells answer one more than the tails'
# own prefix when the heads agree and `0n` when they do not -- the prelude's
# `P.is_eq` decides that, and `P.gate` turns the decision into the length. Both
# list types are `List<&2, Nat>`, which is the type the laws are stated over.
def lcp_len(xs: List<&2, Nat>, ys: List<&2, Nat>) -> Nat:
  ?TODO
