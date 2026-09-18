import Base
import ./prelude.bend as P

# TODO(policy): implement. `count_odd_prefix(n, xs)` counts the odd numbers
# among the first `n` elements of `xs`, so it is `0n` once either the count or
# the list runs out. `n` is the argument that gets consumed: `0n` is the base
# case, and the step splits the list -- `Nil{}` counts none, and a cons cell
# adds `P.is_odd(h)` to `count_odd_prefix(k, t)`.
def count_odd_prefix(n: Nat, xs: List<Nat>) -> Nat:
  ?TODO
