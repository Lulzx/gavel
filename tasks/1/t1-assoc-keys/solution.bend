import Base
import ./prelude.bend as P

# TODO(policy): implement. `assoc_put(kvs, k, v)` stores `v` under `k` by
# putting the new entry at the front, so it is the entry a later reader meets
# first. The list is not walked: the answer is the new pair consed onto `kvs`.
def assoc_put(kvs: List<&2, P.Entry>, k: Nat, v: Nat) -> List<&2, P.Entry>:
  ?TODO

# TODO(policy): implement. `keys(kvs)` collects the keys in the order the
# entries appear. Recurse on `kvs`: the empty association list has no keys, and
# a cons cell puts its own key in front of the keys of its tail.
def keys(kvs: List<&2, P.Entry>) -> List<&2, Nat>:
  ?TODO
