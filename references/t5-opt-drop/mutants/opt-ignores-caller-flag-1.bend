import Base
import ./prelude.bend as P

# The optimiser reads a flag, but not the caller's: it assumes the accumulator
# is zero where the program starts and works out the rest from there. On `True`
# it is the reference one, so `opt_sound_zero` holds; on `False` it removes a
# `Twice` it has no licence for, so `opt_sound` does not. The two soundness laws
# are separate for this body: collapsing them into one stated over a single
# starting state would have to pick a flag, and either choice leaves this
# optimiser proving the law that was kept.
#
# The helper is under `Policy.` because the gate allows a submission to declare
# only the policy's own names plus `Policy.*`, so a body that wants a second
# recursion has to put it there.
def Policy.go(prog: List<&2, P.Op>, z: Bool) -> List<&2, P.Op>:
  match prog:
    case Nil{}:
      Nil{}
    case P.Zero{} <> t:
      P.Zero{} <> Policy.go(t, True{})
    case P.Twice{} <> t:
      match z:
        case True{}:
          Policy.go(t, True{})
        case False{}:
          P.Twice{} <> Policy.go(t, False{})
    case P.Inc{} <> t:
      P.Inc{} <> Policy.go(t, False{})

def opt(prog: List<&2, P.Op>, z: Bool) -> List<&2, P.Op>:
  Policy.go(prog, True{})
