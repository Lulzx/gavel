import Base
import ./prelude.bend as P

# TODO(policy): implement both projections. `values(kvs)` answers the list of
# the values stored in the association list, in the order the entries occur, and
# `sum_values(kvs)` answers their sum.
#
# Each recurses on `kvs`: `Nil{}` answers `Nil{}` and `0n` respectively, and a
# cons cell projects its value onto the front of the projection of its tail, and
# adds its value to the sum of its tail. The key is read only by the pattern and
# is not used by either.
def values(kvs: List<&2, P.Entry>) -> List<&2, Nat>:
  ?TODO

def sum_values(kvs: List<&2, P.Entry>) -> Nat:
  ?TODO
