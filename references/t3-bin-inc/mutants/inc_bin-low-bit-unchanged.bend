import Base
import ./prelude.bend as P

# The low `O{}` case keeps the bit it found and carries anyway, so the number's
# low bit never flips: the increment only ever reaches a higher position. The
# empty case is the reference's, and the `I{}` case is untouched, so
# `inc_bin_nil` holds; `inc_bin_zero` is the definitional law this body breaks
# (`O{} <> inc_bin(t)` against `I{} <> t`, at a variable `t`), and `to_nat_inc`
# fails with it. Measured: rejected at `Policy.to_nat_inc_general`, the work
# law's helper.
def inc_bin(bs: List<&2, P.Bit>) -> List<&2, P.Bit>:
  match bs:
    case Nil{}:
      P.I{} <> Nil{}
    case h <> t:
      match h:
        case P.O{}:
          P.O{} <> inc_bin(t)
        case P.I{}:
          P.O{} <> inc_bin(t)
