import Base
import ./prelude.bend as P

# The symbol is push-ed at the wrong end: it goes on the front of the stack, as
# the oldest rather than the newest entry. `P.snoc` and `<>` are different
# functions, and the stack now reads the symbol before everything already on it,
# which is what the pins and the length law catch -- the invariant is preserved
# either way, since the multiset of symbols is unchanged.
def step(xs: List<&2, P.Sym>, s: P.Sym) -> List<&2, P.Sym>:
  match s:
    case P.Op{}:
      P.Op{} <> xs
    case P.Cl{}:
      P.Cl{} <> xs
