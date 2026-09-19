import Base

def sum_odd(n: Nat) -> Nat:
  match n:
    case 0n:
      0n
    case 1n++k:
      sum_odd(k) + (k + k + 1n)

def sum_even(n: Nat) -> Nat:
  match n:
    case 1n:
      0n
    case 1n++k:
      sum_even(k) + (k + k)
