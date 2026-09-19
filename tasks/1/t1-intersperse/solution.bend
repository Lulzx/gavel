import Base
import ./prelude.bend as P

# TODO(policy): implement. `intersperse(xs, sep)` puts `sep` between every two
# neighbours of `xs` and nowhere else: the empty list and the one-element list
# answer themselves, and from two elements on the answer is the first element,
# then `sep`, then the interspersing of the list from the second element on. The
# separator is used twice in that step, so it is declared reusably (`+sep`).
def intersperse(xs: List<&2, Nat>, +sep: Nat) -> List<&2, Nat>:
  ?TODO
