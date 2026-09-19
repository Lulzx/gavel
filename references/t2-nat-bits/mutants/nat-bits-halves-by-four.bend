import Base
import ./prelude.bend as P

# The reference with the number quartered instead of halved between steps: the
# width is still one element per unit, so the list is the right length and the
# low bit is still the low bit, and every bit above the first is taken from the
# wrong place.
#
# Measured 2026-09-19 under this task's own reference proof: tier 3, proving
# `nat_bits_zero` and failing `nat_bits_succ` and `nat_bits_len`.
# `nat_bits_len` fails on the width alone -- the goal becomes
# `1n + P.len(nat_bits(p, Nat.div(n, 4n))) == 1n + p`, and the hypothesis the
# proof needs is at `Nat.div(n, 2n)`, which is a different term.
def nat_bits(w: Nat, +n: Nat) -> List<&2, Nat>:
  match w:
    case 0n:
      Nil{}
    case 1n+p:
      Nat.mod(n, 2n) <> nat_bits(p, Nat.div(n, 4n))
