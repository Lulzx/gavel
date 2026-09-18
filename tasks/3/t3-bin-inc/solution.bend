import Base
import ./prelude.bend as P

# TODO(policy): one more than `bs`, as a bit list, least significant bit first.
# A low `O{}` becomes `I{}` and the increment stops; a low `I{}` becomes `O{}`
# and the carry moves to the next bit up, which is the recursion. The empty
# number increments to one.
def inc_bin(bs: List<&2, P.Bit>) -> List<&2, P.Bit>:
  ?TODO
