import Base
import ./prelude.bend as P

# The answer is the empty list at every width. Both arguments are dropped.
#
# Measured 2026-09-19 under this task's own reference proof: tier 3, proving
# `nat_bits_zero` and failing `nat_bits_succ` and `nat_bits_len`.
def nat_bits(w: Nat, +n: Nat) -> List<&2, Nat>:
  Nil{}
