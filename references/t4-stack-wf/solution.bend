import Base
import ./prelude.bend as P

# The reference solution: the machine reads one symbol and pushes it onto the
# stack, and that is all it does -- `P.snoc` is the prelude's, so the step is
# determined by which symbol it was handed. The proof's work is not in this
# body but in showing that what the body does to a well-formed stack keeps it
# well-formed, which is the invariant law below the pins.
def step(xs: List<&2, P.Sym>, s: P.Sym) -> List<&2, P.Sym>:
  match s:
    case P.Op{}:
      P.snoc(xs, P.Op{})
    case P.Cl{}:
      P.snoc(xs, P.Cl{})
