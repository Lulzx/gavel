import Base
import ./prelude.bend as P

# The run is emitted as one value: the count is read by the pattern and then
# not used, which is exactly the body `expand_cons` was written to catch (its
# comment names it). Measured: rejected at `Policy.expand_len`, the length
# law's induction -- this task's proof carries all three laws on helpers in one
# file, so every wrong body dies there and the law list reports all three
# unproven. The law the body violates is `expand_cons`:
# `repeat(v, k)` and `v <> Nil{}` are not convertible at a variable `k`.
def expand(rs: List<&2, P.Run>) -> List<&2, Nat>:
  match rs:
    case Nil{}:
      Nil{}
    case P.Mk{v, k} <> t:
      v <> expand(t)
