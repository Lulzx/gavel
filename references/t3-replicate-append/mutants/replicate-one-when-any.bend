import Base

# The count is ignored past the first step: any non-zero count yields one copy.
# `replicate_single` holds definitionally and `rev_replicate` holds, so the
# length law is what sees it -- the left-hand side is `1n` and the right-hand
# side is the variable `n`. Measured: `proof_tier=2 bare_tier=2`, nothing
# proven, first failure at `Policy.replicate_snoc`.
def replicate(n: Nat, +x: Nat) -> List<Nat>:
  match n:
    case 0n:
      Nil{}
    case 1n+k:
      x <> Nil{}
