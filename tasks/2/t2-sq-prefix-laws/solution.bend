import Base
import ./prelude.bend as P

# TODO(policy): implement. `sq_prefix(n, xs)` adds up the squares of the first
# `n` elements of `xs`, so it is `0n` once either the count or the list runs
# out. `n` is the argument that gets consumed: `0n` is the base case, and the
# step splits the list -- `Nil{}` adds nothing, and a cons cell adds `P.sq(h)`
# to `sq_prefix(k, t)`.
def sq_prefix(n: Nat, xs: List<Nat>) -> Nat:
  ?TODO
