import Base
import ./prelude.bend as P

# TODO(policy): implement. Recurse on `xs`: the empty list has nothing to drop,
# and a cons cell is thrown away and the tail's answer taken when the head is at
# most `n`, and handed back whole when it is not. The cons step reads the head
# and the tail twice -- once for the recursion and once for the answer it hands
# back -- so `xs` is `+`. `P.le` and `P.drop_put` come from the prelude.
def drop_while(+xs: List<&2, Nat>, +n: Nat) -> List<&2, Nat>:
  ?TODO
