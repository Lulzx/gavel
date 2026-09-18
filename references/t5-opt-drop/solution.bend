import Base
import ./prelude.bend as P

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
      match z:
        case True{}:
          opt(t, True{})
        case False{}:
          P.Twice{} <> opt(t, False{})
    case P.Inc{} <> t:
      P.Inc{} <> opt(t, False{})
