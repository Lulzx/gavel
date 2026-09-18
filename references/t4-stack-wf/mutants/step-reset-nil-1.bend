import Base
import ./prelude.bend as P

# The stack is thrown away and replaced by a one-symbol stack. The result is
# well-formed by construction and has length one, so the invariant law and the
# length law both hold; it is the pins, which say the old stack is still there,
# that reject it.
def step(xs: List<&2, P.Sym>, s: P.Sym) -> List<&2, P.Sym>:
  match s:
    case P.Op{}:
      P.Op{} <> Nil{}
    case P.Cl{}:
      P.Cl{} <> Nil{}
