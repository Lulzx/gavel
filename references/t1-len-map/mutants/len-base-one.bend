import Base
import ./prelude.bend as P

# Wrong: `len` answers `1n` for the empty list. `len_single` is the closed
# anchor that rules it out. (The prelude was imported as `P` and the call
# below was unqualified, so this file did not type-check on its own and no law
# ever saw it.)
def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      1n
    case h <> t:
      1n + len(t)

def map(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      P.inc(h) <> map(t)
