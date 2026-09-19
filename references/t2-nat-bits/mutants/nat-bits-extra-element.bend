import Base
import ./prelude.bend as P

# The reference with a zero wedged in ahead of each recursive step: every bit
# the reference produces is still there, in the right order, and there is one
# extra element per unit of width.
#
# Measured 2026-09-19 under this task's own reference proof: tier 3, proving
# `nat_bits_zero` and failing `nat_bits_succ` and `nat_bits_len`.
def nat_bits(w: Nat, +n: Nat) -> List<&2, Nat>:
  match w:
    case 0n:
      Nil{}
    case 1n+p:
      Nat.mod(n, 2n) <> 0n <> nat_bits(p, Nat.div(n, 2n))
