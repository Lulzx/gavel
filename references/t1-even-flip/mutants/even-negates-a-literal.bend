import Base

# The step negates a literal instead of the predecessor's parity, so `even` is
# `True{}` at zero and `False{}` everywhere else -- the correct answer at zero
# and one, wrong from two on. The law fails at its step case, where the two
# sides are `False{}` and `Bool.not(False{})`.
# Measured: `proof_tier=3 bare_tier=2`, proven ['even_zero'], first failure
# at `LAWS.even_flip`.
def even(n: Nat) -> Bool:
  match n:
    case 0n:
      True{}
    case 1n+p:
      Bool.not(True{})
