import Base
import ./prelude.bend as P

# The empty expression compiles to one instruction emitting a zero. `eval`
# says the empty expression denotes the empty word, so `exec_compile` at
# `P.Empty{}` compares `w` with `w` followed by a zero and rejects it. This is
# the mutant that justifies not writing a definitional pin for `compile`: a
# `compile(P.Empty{}) == Nil{}` law would catch it too, and so would the
# theorem, so the pin would be a second copy of the same fact.
def compile(e: P.Expr) -> List<&2, P.Op>:
  match e:
    case P.Empty{}:
      P.Emit{0n} <> Nil{}
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
