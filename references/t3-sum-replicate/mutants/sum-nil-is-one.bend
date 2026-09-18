import Base

# The empty case is off by one and the fold is right, so the answer is always
# one more than the sum. `sum_cons` holds definitionally -- the cons case is the
# reference's -- and `sum_replicate_mul` fails at count zero, where the
# left-hand side is `1n` and `P.mul(0n, x)` is `0n`. Measured:
# `proof_tier=3 bare_tier=2`, `sum_cons` proven, first failure at
# `LAWS.sum_replicate_mul`.
def sum(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      1n
    case h <> t:
      h + sum(t)
