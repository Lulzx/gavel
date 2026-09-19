import Base

# Immutable, and owned by the task rather than the policy. `nat_bits` is the
# bank's encoder, copied here so that the round-trip law can be stated against
# something the policy does not write, and `low` is the value those bits are
# worth, so that the same law has a right-hand side that does not mention the
# encoder either. The width comes first in both because the recursion shrinks
# the width while it halves the number, and a recursive call is only accepted
# when every argument before the shrinking one is passed unchanged; `n` is
# therefore declared `+n`.

# The low `w` bits of `n`, least significant first.
def nat_bits(w: Nat, +n: Nat) -> List<&2, Nat>:
  match w:
    case 0n:
      Nil{}
    case 1n+p:
      Nat.mod(n, 2n) <> nat_bits(p, Nat.div(n, 2n))

# What the low `w` bits of `n` are worth: the low bit at face value, and
# everything above it worth twice what is left after halving. It matches on the
# width the same way the encoder does, so with a variable width neither side
# reduces and the round-trip law below is an induction rather than an
# unfolding.
def low(w: Nat, +n: Nat) -> Nat:
  match w:
    case 0n:
      0n
    case 1n+p:
      Nat.mod(n, 2n) + 2n * low(p, Nat.div(n, 2n))
