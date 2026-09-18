import Base
import ./prelude.bend as P

# The machine hands back the word it was given and never executes anything.
# `compile` is the reference one, so this is purely an `exec` failure and the
# two laws that name `exec` on a program it cannot step over both reject it:
# `exec_emit` asks for the word with `n` on the end, and `exec_splice` asks the
# second piece to be run at all. `exec_nil` is satisfied -- the empty program
# really is a no-op -- which is why one law about `exec` would not have been
# enough to say what `exec` is.
def compile(e: P.Expr) -> List<&2, P.Op>:
  match e:
    case P.Empty{}:
      Nil{}
    case P.Sym{n}:
      P.Emit{n} <> Nil{}
    case P.Cat{a, b}:
      P.splice(compile(a), compile(b))

def exec(prog: List<&2, P.Op>, w: List<&2, Nat>) -> List<&2, Nat>:
  w
