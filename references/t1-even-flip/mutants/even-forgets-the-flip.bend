import Base

# The step recurses without negating, so `even` is `True{}` everywhere. The law
# is a relation between `even(x)` and `even(1n+x)`, and a constant body makes
# the right-hand side `Bool.not(True{})`, which is `False{}` against a `True{}`
# on the left.
# Measured: `proof_tier=3 bare_tier=2`, proven ['even_zero'], first failure
# at `LAWS.even_flip`.
def even(n: Nat) -> Bool:
  match n:
    case 0n:
      True{}
    case 1n+p:
      even(p)
