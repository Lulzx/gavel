import Base

# `even` is `True{}` at zero and `False{}` at every successor, so it is right at
# zero and one and wrong from two on. The flip law holds at its own base case
# (`True{} == Bool.not(False{})`) and fails at `1n`, where the two sides are
# `False{}` and `Bool.not(False{})`.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.even_flip`.
def even(n: Nat) -> Bool:
  match n:
    case 0n:
      True{}
    case 1n+p:
      False{}
