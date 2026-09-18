import Base
import ./prelude.bend as P

# TODO(policy): the sum `0n + 1n + ... + n`. The empty sum is `0n`, and each step
# adds the new top on: `sum_to(p) + (1n + p)`. Both sides of the step mention
# `p`, once as the argument of the recursion and once in the added term, so the
# pattern variable is not usable live twice without a `+p = p` rebind.
def sum_to(n: Nat) -> Nat:
  ?TODO
