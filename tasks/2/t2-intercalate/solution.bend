import Base
import ./prelude.bend as P

# TODO(policy): implement. Recurse on `xss`; the empty collection of lists has
# nothing to join, so it answers the empty list. A one-element collection has no
# gap either, so its answer is that one list. From two lists on the answer is the
# first list, then the separator, then the joining of everything from the second
# list on. The separator is emitted in the step and handed on to the recursive
# call, so it is read twice.
def intercalate(sep: List<&2, Nat>, xss: List<&2, List<&2, Nat>>) -> List<&2, Nat>:
  ?TODO
