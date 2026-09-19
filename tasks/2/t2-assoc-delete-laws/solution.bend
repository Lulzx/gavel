import Base
import ./prelude.bend as P

# TODO(policy): implement. `assoc_delete(k, kvs)` removes the *first* entry of
# `kvs` whose key is `k` and keeps every other entry in the order it was in; if
# no entry carries `k`, the whole association list comes back. Recurse on the
# list: the empty list has no entry to remove, and a cons cell compares its
# key with `k` and either answers its tail -- dropping the entry whole -- or
# keeps its entry in front of the removal from the tail.
#
# The comparison is `P.key_select(hk, k, x, y)`, which answers `x` when the two
# keys are equal and `y` otherwise: a match cannot scrutinise a computed
# comparison, so the decision is passed on rather than taken here. Both answers
# are association lists, so the step can either drop the entry or keep it.
def assoc_delete(+k: Nat, kvs: List<&2, P.Entry>) -> List<&2, P.Entry>:
  ?TODO
