import Base
import ./prelude.bend as P

# Every `Twice` is removed, whether or not the accumulator is zero when it is
# reached. `clean_opt` is happy -- the output has no `Twice` left at all -- and
# `opt_sound` is not: on `P.Twice{} <> Nil{}` the optimised program gives back
# the accumulator it was handed and the original gives back twice that. This is
# the body that shows why `clean_opt` cannot be the whole specification of the
# optimiser: a program can be as clean as you like and still be wrong.
def exec(prog: List<&2, P.Op>, +s: Nat) -> Nat:
  match prog:
    case Nil{}:
      s
    case P.Zero{} <> t:
      exec(t, 0n)
    case P.Inc{} <> t:
      exec(t, 1n + s)
    case P.Twice{} <> t:
      exec(t, s + s)

def opt(prog: List<&2, P.Op>, z: Bool) -> List<&2, P.Op>:
  match prog:
    case Nil{}:
      Nil{}
    case P.Zero{} <> t:
      P.Zero{} <> opt(t, True{})
    case P.Twice{} <> t:
      opt(t, False{})
    case P.Inc{} <> t:
      P.Inc{} <> opt(t, False{})
