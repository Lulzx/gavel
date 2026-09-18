import Base
import ./prelude.bend as P

def absdiff(+a: Nat, +b: Nat) -> Nat:
  P.sub(a, b) + P.sub(b, a)
