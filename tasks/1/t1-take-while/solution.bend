import Base
import ./prelude.bend as P

# TODO(policy): implement. Recurse on `xs`: the empty list has nothing to take,
# and a cons cell keeps its head and carries on with the tail exactly when the
# head is at most `n`. `P.le` and `P.keep_put` come from the prelude.
def take_while(xs: List<Nat>, +n: Nat) -> List<Nat>:
  ?TODO
