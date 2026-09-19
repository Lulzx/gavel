import Base
import ./prelude.bend as P

# TODO(policy): implement. `collatz_len(fuel, n)` is the number of Collatz steps
# that take `n` to `1n`: halve it when it is even and send it to `3n*n + 1n`
# when it is odd, and count a step each time. The loop does not descend on any
# subterm of the number -- the next value is a computed one -- so the argument
# that shrinks is the budget, handed in first. `0n` of budget answers `0n`: no
# steps were taken. `0n` and `1n` are where the walk stops, and answer `0n` too.
# Everything else takes one step, which is `1n +` the walk on the budget below,
# at the next value: `Bool.pick` of whether the number is even chooses between
# `P.half` and `3n*n + 1n`. The number is read in four places there, so it is
# declared reusable: `+n`.
def collatz_len(fuel: Nat, +n: Nat) -> Nat:
  ?TODO
