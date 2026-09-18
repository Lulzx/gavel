import Base
import ./prelude.bend as P

# The step recurses on the tail without counting the head, so the answer is
# the aggregate of the elements after the first `n`. The zero law holds and
# the length law fails at `P.len` of a cons.
# Measured: `proof_tier=3 bare_tier=2`, proven ['sum_prefix_zero'], first
# failure at `LAWS.sum_prefix_len`.
def sum_prefix(n: Nat, xs: List<Nat>) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+k:
      match xs:
        case Nil{}:
          0n
        case h <> t:
          sum_prefix(k, t)
