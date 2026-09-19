import Base
import ./prelude.bend as P

# TODO(policy): implement. Recurse on `xs`: the empty list spans into two empty
# lists, and a cons cell hands the head, the tail and the tail's pair to
# `P.span_put` together with the predicate's answer for the head. The cons step
# reads the head twice and the tail twice, so the parameter is `+xs`, and the
# element type is `&2` so that a second read of an element is legal at all.
def span_below(+xs: List<&2, Nat>, +n: Nat) -> P.PairL:
  ?TODO
