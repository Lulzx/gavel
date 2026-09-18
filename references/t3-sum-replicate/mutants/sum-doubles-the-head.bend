import Base

# The head is added twice, so the answer is the sum plus the first element. The
# cons law fails at a variable head; `sum_replicate_one` fails as well, since a
# run of ones would come back as `n + 1`. Measured: `proof_tier=2 bare_tier=2`,
# nothing proven, first failure at `LAWS.sum_cons`.
def sum(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case +h <> t:
      h + h + sum(t)
