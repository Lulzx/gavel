import Base

# A straight-line machine with three instructions, and a program is a list of
# them read left to right. `Zero` writes zero into the accumulator, `Inc` adds
# one to it, `Twice` doubles it.
type Op is Data:
  Zero{}
  Inc{}
  Twice{}

# The property a program is expected to have, indexed by what is known about
# the accumulator where the program starts: `z` is true when it is known to
# hold zero.
#
# `Twice` is redundant exactly when the accumulator holds zero -- doubling zero
# is zero -- so under this reading of the machine it is out of place there, and
# a program that reaches one is not clean. The flag follows the instructions: a
# `Zero` leaves the accumulator zero, and every other instruction leaves it
# something else, because `Twice` on a nonzero accumulator is neither zero nor
# redundant.
def clean(p: List<&2, Op>, +z: Bool) -> Bool:
  match p:
    case Nil{}:
      True{}
    case Zero{} <> t:
      clean(t, True{})
    case Twice{} <> t:
      match z:
        case True{}:
          False{}
        case False{}:
          clean(t, False{})
    case Inc{} <> t:
      clean(t, False{})
