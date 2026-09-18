import Base
import ./prelude.bend as P

# The empty number increments to the bits of zero rather than to one: the sum
# law would then need `0 == 1` at the base. Every other case is the reference's,
# so the only law that can see it is the definitional base -- `inc_bin_nil`,
# where `O{} <> Nil{}` and `I{} <> Nil{}` do not convert. Measured: rejected at
# `Policy.to_nat_inc_general`, this proof's work helper, with all three laws
# reported unproven.
def inc_bin(bs: List<&2, P.Bit>) -> List<&2, P.Bit>:
  match bs:
    case Nil{}:
      P.O{} <> Nil{}
    case h <> t:
      match h:
        case P.O{}:
          P.I{} <> t
        case P.I{}:
          P.O{} <> inc_bin(t)
