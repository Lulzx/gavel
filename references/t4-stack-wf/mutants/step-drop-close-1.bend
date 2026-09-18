import Base
import ./prelude.bend as P

# A closing symbol is dropped rather than pushed: the machine treats `Cl` as a
# no-op and only ever grows the stack. Well-formedness survives -- dropping a
# close never makes a stack worse -- so the invariant law is happy with it, and
# only the pin on `Cl` rejects it.
def step(xs: List<&2, P.Sym>, s: P.Sym) -> List<&2, P.Sym>:
  match s:
    case P.Op{}:
      P.snoc(xs, P.Op{})
    case P.Cl{}:
      xs
