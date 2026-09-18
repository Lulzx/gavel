import Base
import ./prelude.bend as P

# The low `O{}` case both sets the bit and carries on incrementing the tail, so
# the answer is one more than it should be and the increment never stops at the
# first empty position. Read the shape when the tail is empty: `I{} <> I{} <>
# Nil{}`, where the law wants `I{} <> Nil{}` -- so `inc_bin_zero` is already
# unconvertible. `to_nat_inc` fails as well. Measured: rejected at
# `Policy.to_nat_inc_general`, the work law's helper.
def inc_bin(bs: List<&2, P.Bit>) -> List<&2, P.Bit>:
  match bs:
    case Nil{}:
      P.I{} <> Nil{}
    case h <> t:
      match h:
        case P.O{}:
          P.I{} <> inc_bin(t)
        case P.I{}:
          P.O{} <> inc_bin(t)
