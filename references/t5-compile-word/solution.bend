import Base
import ./prelude.bend as P

def compile(e: P.Expr) -> List<&2, P.Op>:
  match e:
    case P.Empty{}:
      Nil{}
    case P.Sym{n}:
      P.Emit{n} <> Nil{}
    case P.Cat{a, b}:
      P.splice(compile(a), compile(b))

def exec(prog: List<&2, P.Op>, w: List<&2, Nat>) -> List<&2, Nat>:
  match prog:
    case Nil{}:
      w
    case P.Emit{n} <> t:
      exec(t, P.glue(w, n <> Nil{}))
