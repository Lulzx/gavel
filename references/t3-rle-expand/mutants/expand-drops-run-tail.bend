import Base
import ./prelude.bend as P

# The first run is decoded correctly and the rest of the run list is thrown
# away -- the recursion is written but its result is not used, which is what a
# body looks like when the author thinks of `expand` as "decode one run".
# Measured: rejected at `Policy.expand_len`. The law the body violates is
# `expand_len` itself (only the head's values are counted) and `expand_cons`
# too, since the tail of the run list never reaches the answer.
def expand(rs: List<&2, P.Run>) -> List<&2, Nat>:
  match rs:
    case Nil{}:
      Nil{}
    case P.Mk{v, k} <> t:
      P.append(P.repeat(v, k), Nil{})
