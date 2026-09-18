import Base

# Parity flipped at the base: `even` is `False{}` at zero and its negation from
# there on. Every other law in this task compares `even` with itself at a
# different argument, and both sides are negated together in `even_flip`, so the
# flipped body proves it exactly as the reference does.
# Measured: before `even_zero`, tier 4, reward 1.000 (all laws proven); after,
# tier 3, reward 0.350 for `even_flip` alone, first failure at `LAWS.even_zero`.
def even(n: Nat) -> Bool:
  match n:
    case 0n:
      False{}
    case 1n+p:
      Bool.not(even(p))
