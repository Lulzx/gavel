import Base
import ./prelude.bend as P

# TODO(policy): `compile` recurses on the expression, `exec` on the program it
# is handed. `P.Empty{}` is the empty expression and `P.Cat{a, b}` the
# concatenation, so a body that answers `compile(P.Empty{})`, `compile(P.Sym{n})`
# and `compile(P.Cat{a, b})` answers every expression there is.

def compile(e: P.Expr) -> List<&2, P.Op>:
  ?TODO

def exec(prog: List<&2, P.Op>, w: List<&2, Nat>) -> List<&2, Nat>:
  ?TODO
