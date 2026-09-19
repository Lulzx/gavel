import Base
import ./prelude.bend as P

# PROBE. The two empty anchors hold and the step keeps the prelude's strict
# comparison, but adds one per cons cell.
def count_inv(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> +t:
      P.count_gt(h, t) + 1n + count_inv(t)
