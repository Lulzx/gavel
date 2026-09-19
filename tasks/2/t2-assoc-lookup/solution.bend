import Base
import ./prelude.bend as P

# TODO(policy): implement. `assoc_lookup(kvs, k)` answers the value stored under
# `k`, or `0n` when no entry carries that key. Recurse on `kvs`: the empty
# association list has no answer, and a cons cell answers its own value when its
# key is `k` and otherwise defers to the lookup in its tail.
#
# The comparison is the prelude's `P.key_select`, because a `match` cannot
# scrutinise a computed comparison: `P.key_select(hk, k, hv, <tail's answer>)`
# is the value of the head when `hk` is `k` and the tail's answer otherwise.
# Both arguments are written, so the call is not tail-recursive.
def assoc_lookup(kvs: List<&2, P.Entry>, +k: Nat) -> Nat:
  ?TODO
