import Base
import ./prelude.bend as P

# `step` returns the stack it was given: neither symbol is pushed. It
# type-checks -- the stack is a stack either way -- and no invariant is broken,
# since a well-formed stack stays well-formed when nothing happens to it. It is
# the two definitional pins that reject it.
def step(xs: List<&2, P.Sym>, s: P.Sym) -> List<&2, P.Sym>:
  match s:
    case P.Op{}:
      xs
    case P.Cl{}:
      xs
