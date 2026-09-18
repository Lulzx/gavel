import Base

def even(n: Nat) -> Bool:
  match n:
    case 0n:
      True{}
    case 1n+p:
      Bool.not(even(n))
