import Base

# Each step puts two copies down, so `replicate(n, x)` has `2n` elements. The
# length law is exact rather than a bound, which is what makes it catch an
# over-long run and not only a short one; the append law fails as well.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `Policy.replicate_snoc`.
def replicate(n: Nat, +x: Nat) -> List<Nat>:
  match n:
    case 0n:
      Nil{}
    case 1n+k:
      x <> x <> replicate(k, x)
