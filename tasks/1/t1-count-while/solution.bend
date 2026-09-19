import Base
import ./prelude.bend as P

# TODO(policy): implement. Recurse on `xs`: the empty list counts nothing, and a
# cons cell contributes one plus the tail's count exactly when the head is at
# most `n`. `P.le` and `P.count_put` come from the prelude.
def count_while(xs: List<Nat>, +n: Nat) -> Nat:
  ?TODO
