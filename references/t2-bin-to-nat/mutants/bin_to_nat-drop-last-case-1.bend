import Base
import ./prelude.bend as P

def bin_to_nat(bs: List<&2, Nat>) -> Nat:
  match bs:
    case Nil{}:
      0n
