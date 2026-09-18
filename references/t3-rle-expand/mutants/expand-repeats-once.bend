import Base
import ./prelude.bend as P

# The run's value is decoded through `repeat` but with a fixed count of one, so
# the body is a plain one-value-per-run decoding: the pattern still binds `k`
# and the shape of the recursion is right, which is what makes this the
# plausible near miss rather than an obvious stub. Measured: rejected at
# `Policy.expand_len`. The law the body violates is `expand_len` (the count
# never reaches the length) and `expand_cons`, where `repeat(v, 1n)` and
# `repeat(v, k)` are not convertible at a variable `k`.
def expand(rs: List<&2, P.Run>) -> List<&2, Nat>:
  match rs:
    case Nil{}:
      Nil{}
    case P.Mk{v, k} <> t:
      P.append(P.repeat(v, 1n), expand(t))
