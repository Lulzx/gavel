import Base
import ./prelude.bend as P

def clamp(x: Nat, lo: Nat, hi: Nat, klo: Bool, khi: Bool) -> Nat:
  match klo:
    case True{}:
      lo
