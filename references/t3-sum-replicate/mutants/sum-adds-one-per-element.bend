import Base

# Each element contributes one instead of itself: the fold counts successors.
# `sum_replicate_one` holds, since a run of ones summed either way is the count,
# and `sum_replicate_mul` holds at `x = 1n`; `sum_cons` is the law that fails,
# where the head is a variable and the right-hand side wants it added.
# Measured: `proof_tier=3 bare_tier=2`, `sum_replicate_one` proven, first
# failure at `LAWS.sum_cons`.
def sum(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + sum(t)
