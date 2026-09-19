import Base
import ./prelude.bend as P

# TODO(policy): implement. `assoc_update(kvs, k, v)` changes the value stored
# under `k` to `v` and leaves every other entry alone. It does *not* insert: a
# key the association list does not carry is a key nothing happens for, so the
# empty association list updates to itself.
#
# Recurse on `kvs`: `Nil{}` returns `Nil{}`, and a cons cell answers the list
# with its value replaced when its key is `k` and otherwise keeps its own entry
# in front of the update of its tail. The comparison is the prelude's
# `P.key_select`, because a `match` cannot scrutinise a computed comparison, and
# both of its list arguments are written, so the query, the value and the
# tail are read in both branches and have to be `+` parameters.
def assoc_update(kvs: List<&2, P.Entry>, +k: Nat, +v: Nat) -> List<&2, P.Entry>:
  ?TODO
