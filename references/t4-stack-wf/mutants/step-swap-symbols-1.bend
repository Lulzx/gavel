import Base
import ./prelude.bend as P

# The near-miss: a symbol is always pushed, and the stack always grows by one,
# but the two branches push each other's symbol. Everything the machine does
# looks right -- the length law holds unconditionally, the given symbol is
# still consumed, well-formedness survives -- and only the two definitional pins
# notice that `Op` was stored as a `Cl`.
def step(xs: List<&2, P.Sym>, s: P.Sym) -> List<&2, P.Sym>:
  match s:
    case P.Op{}:
      P.snoc(xs, P.Cl{})
    case P.Cl{}:
      P.snoc(xs, P.Op{})
