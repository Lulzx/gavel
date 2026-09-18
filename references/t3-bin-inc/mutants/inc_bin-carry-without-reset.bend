import Base
import ./prelude.bend as P

# The carry moves up to the next bit but the bit it came from is not written:
# a low `I{}` disappears instead of becoming `O{}`, so the answer is one bit
# shorter than the input whenever a carry happens. Read it at `bs = I{} <>
# Nil{}`: the body gives `I{} <> Nil{}` where the law wants `O{} <> I{} <>
# Nil{}`. The empty case and the low `O{}` case are the reference's, so the two
# definitional laws hold; the value law is the one that fails. Measured:
# rejected at `Policy.to_nat_inc_general`, the work law's helper.
def inc_bin(bs: List<&2, P.Bit>) -> List<&2, P.Bit>:
  match bs:
    case Nil{}:
      P.I{} <> Nil{}
    case h <> t:
      match h:
        case P.O{}:
          P.I{} <> t
        case P.I{}:
          inc_bin(t)
