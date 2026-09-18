import Base
import ./prelude.bend as P

# TODO(policy): implement. `max_prefix(n, xs)` is the largest of the first `n`
# elements of `xs`, and `0n` once either the count or the list runs out. `n` is
# the argument that gets consumed: `0n` is the base case, and the step splits
# the list -- `Nil{}` is `0n`, and a cons cell takes `P.max(h, max_prefix(k, t))`.
def max_prefix(n: Nat, xs: List<Nat>) -> Nat:
  ?TODO
