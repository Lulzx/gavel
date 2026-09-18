import Base
import ./prelude.bend as P

# The machine applies the first instruction and stops. The four `exec_*` laws
# are stated over an arbitrary tail rather than over a one-instruction program,
# so each of the three instruction laws asks what happens *after* the
# instruction and is answered with the accumulator the first step produced. Had
# they been stated over `P.Zero{} <> Nil{}` and its like, all four would hold of
# this body, the optimiser's laws would not notice it either -- the programs
# they compare are truncated in the same way on both sides -- and the task would
# have paid for a machine that reads one instruction.
def exec(prog: List<&2, P.Op>, +s: Nat) -> Nat:
  match prog:
    case Nil{}:
      s
    case P.Zero{} <> t:
      0n
    case P.Inc{} <> t:
      1n + s
    case P.Twice{} <> t:
      s + s

def opt(prog: List<&2, P.Op>, z: Bool) -> List<&2, P.Op>:
  match prog:
    case Nil{}:
      Nil{}
    case P.Zero{} <> t:
      P.Zero{} <> opt(t, True{})
    case P.Twice{} <> t:
      match z:
        case True{}:
          opt(t, True{})
        case False{}:
          P.Twice{} <> opt(t, False{})
    case P.Inc{} <> t:
      P.Inc{} <> opt(t, False{})
