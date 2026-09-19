import Base
import ./prelude.bend as P

# TODO(policy): implement. `bin_to_nat(bs)` reads a list of bits, least
# significant first, back into the number it came from. Recurse on `bs`: the
# empty list is worth zero, and a cons cell is worth its head plus twice
# whatever its tail is worth, because one position further left is one position
# more significant.
def bin_to_nat(bs: List<&2, Nat>) -> Nat:
  ?TODO
