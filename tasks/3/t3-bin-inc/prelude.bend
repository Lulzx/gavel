import Base

# Immutable, and owned by the task rather than the policy. A natural number is
# written here as a list of bits, least significant first, and the only thing
# the laws need is the reading back.

type Bit is Data:
  O{}
  I{}

# A bit as the number it contributes.
def bit_val(b: Bit) -> Nat:
  match b:
    case O{}:
      0n
    case I{}:
      1n

# Twice a number. Spelled as a function rather than as `2n * n` so that the
# arithmetic in the proof is addition and not multiplication.
def double(+n: Nat) -> Nat:
  n + n

# The value of a bit list, least significant bit first. It matches on the list,
# so with a variable list the goal does not reduce, and the work below is an
# induction rather than an unfolding.
def to_nat(bs: List<&2, Bit>) -> Nat:
  match bs:
    case Nil{}:
      0n
    case h <> t:
      bit_val(h) + double(to_nat(t))
