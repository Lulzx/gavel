import Base
import ./prelude.bend as P

# The machine executes the first instruction and stops. `exec_nil` and
# `exec_emit` both survive, because a program of one instruction has no tail to
# drop, and `compile` is the reference one, so `exec_compile` fails only on
# expressions whose word is longer than one symbol. `exec_splice` is the law
# built for this: it is the only one that says the piece *after* the first is
# run, and it is stated over an arbitrary program rather than over a singleton.
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
      P.glue(w, n <> Nil{})
