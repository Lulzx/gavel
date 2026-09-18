import Base

# The reference solution: multiplication steps on its first argument, the way
# Base's own `Nat.mul` does, so the second factor is a parameter throughout
# every induction below.
def mul(a: Nat, +b: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      b + mul(p, b)
