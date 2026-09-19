import Base

# Immutable, and owned by the task rather than the policy. `lcp_list` is what
# the policy writes; the two definitions here are the comparison it branches on
# and the gate that takes the branch, because the answer of a comparison is not
# something a `match` may scrutinise.

# `is_eq(a, b)` is `1n` when the two elements are equal and `0n` otherwise, by
# descent on both at once.
def is_eq(a: Nat, b: Nat) -> Nat:
  match a b:
    case 0n 0n:
      1n
    case 0n 1n+bp:
      0n
    case 1n+ap 0n:
      0n
    case 1n+ap 1n+bp:
      is_eq(ap, bp)

# `gate_list(c, xs)` is `xs` when `c` is non-zero and `Nil{}` when it is zero.
# The prefix stops at the first position where the two lists disagree, and
# "these two elements disagree" is a comparison the policy cannot match on, so
# the two outcomes are handed to this function together and it returns one of
# them. The case that answers `Nil{}` does not force what it drops.
def gate_list(c: Nat, xs: List<&2, Nat>) -> List<&2, Nat>:
  match c:
    case 0n:
      Nil{}
    case 1n+q:
      xs
