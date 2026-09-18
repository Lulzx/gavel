import Base
import ./prelude.bend as P

def absdiff(+a: Nat, +b: Nat) -> Nat:
  P.sub(b, a) + P.sub(b, a)
