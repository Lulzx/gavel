import Base
import ./prelude.bend as P

# `Cat{a, b}` compiles to b's program followed by a's. Every pin still holds --
# the singleton cases are untouched and `exec_splice` is about `exec` alone --
# and `exec_compile` is the law with an opinion, because `eval` reads the
# expression's two halves in order and this compiler emits them the other way
# round. The word a program denotes is where the order is observable; nothing in
# this task's types says a word is a *set* of symbols, which is why the swap is
# not invisible.
def compile(e: P.Expr) -> List<&2, P.Op>:
  match e:
    case P.Empty{}:
      Nil{}
    case P.Sym{n}:
      P.Emit{n} <> Nil{}
    case P.Cat{a, b}:
      P.splice(compile(b), compile(a))

def exec(prog: List<&2, P.Op>, w: List<&2, Nat>) -> List<&2, Nat>:
  match prog:
    case Nil{}:
      w
    case P.Emit{n} <> t:
      exec(t, P.glue(w, n <> Nil{}))
