import Base
import ./prelude.bend as P

# Every successor count is answered with the count itself, so the list is
# never inspected. The zero law holds and the length law fails, since the
# body leaves a term built out of `n` where the law asks for the aggregate.
# Measured: `proof_tier=3 bare_tier=2`, proven ['max_prefix_zero'], first
# failure at `LAWS.max_prefix_len`.
def max_prefix(n: Nat, xs: List<Nat>) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+k:
      1n+k
