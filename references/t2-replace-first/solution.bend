import Base
import ./prelude.bend as P

# The head is read twice -- once by the comparison and once by the step -- and
# so is the tail, which the step is handed and the walk is handed again, so both
# are marked reusable. `k` and `y` are read twice for the same reason. The
# decision goes to `P.rp_branch` rather than being matched on here, because a
# `match` cannot scrutinise the result of a call.
def replace_first(xs: List<&2, Nat>, +k: Nat, +y: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> +t:
      P.rp_branch(P.eq(h, k), h, y, t, replace_first(t, k, y))
