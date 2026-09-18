import Base

def even(n: Nat) -> Bool:
  match n:
    case 1n:
      True{}
    case 1n+p:
      Bool.not(even(p))
