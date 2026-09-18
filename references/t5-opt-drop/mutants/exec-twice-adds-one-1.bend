import Base
import ./prelude.bend as P

# `Twice` computes `2s + 1` -- the doubling is there, the instruction is simply
# not the one the machine has. `exec_twice` is the law: it fixes the state the
# tail is run from, so a body that doubles and then adds something fails it,
# and so does one that adds something and then doubles. Nothing about the
# optimiser can hide this, because the accumulator is not in any program text.
def exec(prog: List<&2, P.Op>, +s: Nat) -> Nat:
  match prog:
    case Nil{}:
      s
    case P.Zero{} <> t:
      exec(t, 0n)
    case P.Inc{} <> t:
      exec(t, 1n + s)
    case P.Twice{} <> t:
      exec(t, 1n + s + s)

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
