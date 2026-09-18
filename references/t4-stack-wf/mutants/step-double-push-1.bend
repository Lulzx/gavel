import Base
import ./prelude.bend as P

# An `Op` is pushed twice: the machine over-counts its opens. The stack is still
# well-formed -- an extra open is a credit, not a debt -- so the invariant law
# accepts it, and the length law is what says the stack grew by more than one.
def step(xs: List<&2, P.Sym>, s: P.Sym) -> List<&2, P.Sym>:
  match s:
    case P.Op{}:
      P.snoc(P.snoc(xs, P.Op{}), P.Op{})
    case P.Cl{}:
      P.snoc(xs, P.Cl{})
