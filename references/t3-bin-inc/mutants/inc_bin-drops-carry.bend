import Base
import ./prelude.bend as P

# The carry is raised at the low bit and then dropped: a low `I{}` becomes
# `O{}` and the rest of the number is left as it was. This is the plausible
# slip -- the case was written as a rewrite of the bit rather than as a rewrite
# of the bit *plus a carry into the tail* -- and it is the one the definitional
# laws cannot see, because both of them touch only the positions before the
# first `I{}`. `to_nat_inc` is the law that fails: `to_nat(O{} <> t)` is not
# `1n + to_nat(I{} <> t)`. Measured: rejected at `Policy.to_nat_inc_general`,
# the work law's helper, with all three laws reported unproven.
def inc_bin(bs: List<&2, P.Bit>) -> List<&2, P.Bit>:
  match bs:
    case Nil{}:
      P.I{} <> Nil{}
    case h <> t:
      match h:
        case P.O{}:
          P.I{} <> t
        case P.I{}:
          P.O{} <> t
