import Base
import ./prelude.bend as P

# TODO(policy): implement. `count_key(kvs, k)` answers how many entries carry
# the key `k`. Recurse on `kvs`: the empty association list holds none, and a
# cons cell adds one to the count for its tail when its key is `k` and adds
# nothing otherwise.
#
# The comparison is the prelude's `P.key_select`, because a `match` cannot
# scrutinise a computed comparison. Because the tail is counted in both
# branches of the comparison and the query is read in both, `kvs`'s tail and
# `k` have to be reusable parameters.
def count_key(kvs: List<&2, P.Entry>, +k: Nat) -> Nat:
  ?TODO
