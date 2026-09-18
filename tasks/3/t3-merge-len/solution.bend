import Base
import ./prelude.bend as P

# TODO(policy): implement both.
#
# `merge(xs, ys)` returns the two lists merged by comparing their heads with
# `P.le`: the list with the smaller head is advanced and the other keeps its
# head. `merge_go(tx, hx, ty, hy, k)` is the step, and it is here because of a
# Bend restriction rather than for convenience: **a `match` cannot scrutinise a
# computed value**, so `case P.le(hx, hy):` inside `merge` is not a thing you
# can write. It continues a merge in which the left list is `hx <> tx`, the
# right list is `hy <> ty`, and `k` is the already-computed `P.le(hx, hy)` --
# which it matches as a parameter, one step behind the heads it must compare
# next, so the heads that decide the *following* call have to come from matches
# that happen before it.
def merge_go(tx: List<&2, Nat>, +hx: Nat, ty: List<&2, Nat>, +hy: Nat, k: Bool) -> List<&2, Nat>:
  ?TODO

def merge(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, Nat>:
  ?TODO
