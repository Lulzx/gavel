import Base
import ./prelude.bend as P

# TODO(policy): implement. Recurse on `xs`: the empty list partitions into two
# empty lists, and a cons cell hands the head, the tail's pair and the
# predicate's answer for the head to `P.part_put`. The cons step reads the head
# twice -- once for the predicate and once for whichever half it joins -- so the
# parameter is `+xs`, and the element type is `&2` so that a second read of an
# element is legal at all.
def partition_below(+xs: List<&2, Nat>, +n: Nat) -> P.PairL:
  ?TODO
