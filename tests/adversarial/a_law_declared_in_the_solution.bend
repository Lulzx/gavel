import Base

law add_plus:
  for x: Nat
  for y: Nat
  {add(x, 1n+y) == 1n+add(x, y) : Nat}

def add(a: Nat, b: Nat) -> Nat:
  ?TODO
