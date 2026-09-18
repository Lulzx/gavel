import Base
import ./prelude.bend as P

# The step answers the head and stops, so only the first element is ever
# counted. The zero law holds and the length law fails on any list of more
# than one element.
# Measured: `proof_tier=3 bare_tier=2`, proven ['max_prefix_zero'], first
# failure at `LAWS.max_prefix_len`.
def max_prefix(n: Nat, xs: List<Nat>) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+k:
      match xs:
        case Nil{}:
          0n
        case h <> t:
          h
