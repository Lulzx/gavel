import Base
import ./prelude.bend as P

# TODO(policy): implement. `zeros_prefix(n, xs)` counts the zeros among the
# first `n` elements of `xs`: `0n` counts nothing, and each step adds
# `is_zero(h)` for the head and continues one cell further in, so either
# argument running out gives `0n`.
def zeros_prefix(n: Nat, xs: List<Nat>) -> Nat:
  ?TODO
