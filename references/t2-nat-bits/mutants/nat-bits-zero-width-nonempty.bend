import Base
import ./prelude.bend as P

# The reference with the empty case given a one-element answer instead: the
# recursion is the reference's at every width above zero, and the answer at
# width zero is a bit rather than nothing.
#
# Measured 2026-09-19 under this task's own reference proof: tier 3, proving
# `nat_bits_succ` and failing `nat_bits_zero` and `nat_bits_len`. This is the
# mutant the base-case rule asks for: `nat_bits_zero`'s left-hand side is the
# ground term `nat_bits(0n, n)`, the generator rewrites steps and never the
# answer a stopped match gives, and without this file that law would have had
# no mutant failing it while every stage reported the task valid.
def nat_bits(w: Nat, +n: Nat) -> List<&2, Nat>:
  match w:
    case 0n:
      0n <> Nil{}
    case 1n+p:
      Nat.mod(n, 2n) <> nat_bits(p, Nat.div(n, 2n))
