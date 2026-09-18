import Base
import ./prelude.bend as P

# The run's values and the decoding of the rest are appended the wrong way
# round: the list comes out in run-reversed order, with every run's internal
# order intact. Nothing is lost and the empty case is untouched, so the
# order-blind laws do not distinguish it: `expand_len` is true of this body as a
# statement. Measured: rejected anyway, at `Policy.expand_len`, because that
# helper is stated with the append of the reference's own body and this one has
# the operands the other way round. The law the body violates is `expand_cons`,
# and it violates it definitionally.
def expand(rs: List<&2, P.Run>) -> List<&2, Nat>:
  match rs:
    case Nil{}:
      Nil{}
    case P.Mk{v, k} <> t:
      P.append(expand(t), P.repeat(v, k))
