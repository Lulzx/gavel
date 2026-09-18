import Base

# The step negates twice, which is the identity on the predecessor's answer, so
# `even` is `True{}` everywhere -- the same function as the body that forgets
# the flip, written with the negation present. It is here to show that the law
# rejects it for the step rather than for the constant answer: the two sides of
# the law do not reduce to the same term.
# Measured: `proof_tier=3 bare_tier=2`, proven ['even_zero'], first failure
# at `LAWS.even_flip`.
def even(n: Nat) -> Bool:
  match n:
    case 0n:
      True{}
    case 1n+p:
      Bool.not(Bool.not(even(p)))
