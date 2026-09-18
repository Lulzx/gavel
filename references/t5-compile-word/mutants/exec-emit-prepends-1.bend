import Base
import ./prelude.bend as P

# The machine puts each symbol on the *front* of the word instead of the end.
# It still runs the whole program and still threads the state through, so
# `exec_splice` holds and `exec_nil` holds; what breaks is the order the symbols
# come out in, and `exec_emit` is the singleton law that says where an emitted
# symbol lands. A machine that reverses its input is not a machine for this
# language, however faithfully it recurses.
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
      exec(t, n <> w)
