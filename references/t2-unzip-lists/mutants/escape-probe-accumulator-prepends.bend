import Base
import ./prelude.bend as P

# ESCAPE PROBE (alternative algorithm, not a perturbation). The unzip built with
# an explicit accumulator: walk the list once, pushing each half onto the list
# being built. It is the plausible loop, and pushing rather than appending
# hands back both halves reversed.

def Policy.ugo(ps: List<&2, P.Pair>, accs: List<&2, Nat>, accb: List<&2, Nat>) -> P.ZP:
  match ps:
    case Nil{}:
      P.MkZ{accs, accb}
    case +h <> +t:
      Policy.ugo(t, P.pfst(h) <> accs, P.psnd(h) <> accb)

def unzip(ps: List<&2, P.Pair>) -> P.ZP:
  Policy.ugo(ps, Nil{}, Nil{})
