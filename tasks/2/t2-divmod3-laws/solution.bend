import Base
import ./prelude.bend as P

# TODO(policy): implement. Divide by three, answering a `P.Pair` of quotient
# and remainder. Three is the divisor the recursion consumes, so the three
# smallest inputs answer themselves with a zero quotient, and a larger input
# steps down by three and hands the answer to `P.shift`, which is where the
# quotient goes up by one.
def divmod3(n: Nat) -> P.Pair:
  ?TODO
