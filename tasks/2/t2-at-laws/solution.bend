import Base
import ./prelude.bend as P

# TODO(policy): implement. `at(xs, n)` is element `n` of `xs`, counting from
# zero, and `0n` once the list runs out. Match on the list first and then on the
# count: `Nil{}` is `0n`, a cons cell at count `0n` is its head, and a cons cell
# at `1n + k` steps one cell further in, to `at(t, k)`.
def at(xs: List<Nat>, n: Nat) -> Nat:
  ?TODO
