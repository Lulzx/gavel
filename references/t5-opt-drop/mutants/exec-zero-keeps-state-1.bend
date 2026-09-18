import Base
import ./prelude.bend as P

# `Zero` leaves the accumulator as it found it, so the instruction does nothing
# at all. `exec_zero` is the law that says where the `0n` comes from: it fixes
# the state the tail is run from, and the mutant hands it the state it was
# given, so the two sides agree only when `s` happens to be zero. The law is
# stated over an arbitrary tail for the same reason as the others -- a corrupted
# instruction has to be caught in the middle of a program, not only at the front
# of one.
def exec(prog: List<&2, P.Op>, +s: Nat) -> Nat:
  match prog:
    case Nil{}:
      s
    case P.Zero{} <> t:
      exec(t, s)
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
      match z:
        case True{}:
          opt(t, True{})
        case False{}:
          P.Twice{} <> opt(t, False{})
    case P.Inc{} <> t:
      P.Inc{} <> opt(t, False{})
