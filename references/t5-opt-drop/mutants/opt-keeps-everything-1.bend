import Base
import ./prelude.bend as P

# The optimiser that optimises nothing: it hands the program back unchanged.
# Both soundness laws hold of it -- a program that was not rewritten computes
# what it computed -- so the only thing that can reject it is `clean_opt`, and
# `clean_opt` does: it asks for a program with no redundant `Twice`, which is a
# property of the output and not a comparison between two outputs. This is the
# body that shows why the task has a specification law at all and not just a
# pair of correctness laws.
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
    case h <> t:
      h <> opt(t, z)
