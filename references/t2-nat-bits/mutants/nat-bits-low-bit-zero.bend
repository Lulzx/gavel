import Base
import ./prelude.bend as P

# The reference with every element zeroed on the way out: the list has the
# right length and the recursion halves correctly, and no bit of the number
# survives.
#
# Measured 2026-09-19 under this task's own reference proof: tier 3, proving
# `nat_bits_zero` and `nat_bits_len` and failing `nat_bits_succ` only. The
# length law cannot see this one: the answer has exactly as many elements as
# the reference's, and it is `nat_bits_succ` that says which.
def nat_bits(w: Nat, +n: Nat) -> List<&2, Nat>:
  match w:
    case 0n:
      Nil{}
    case 1n+p:
      0n <> nat_bits(p, Nat.div(n, 2n))
