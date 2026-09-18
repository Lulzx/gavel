import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# Stated so that the term to eliminate is on the right.
def Policy.add_zero_right(x: Nat) -> {x == x + 0n : Nat}:
  match x:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_zero_right(p) : {1n + p == 1n + _ : Nat}
      {==}

def Policy.add_reassoc(a: Nat, b: Nat, c: Nat) ->
    {(a + b) + c == a + (b + c) : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_reassoc(p, b, c) : {1n + ((p + b) + c) == 1n + _ : Nat}
      {==}

def L.mul_one_left(x):
  match x:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_zero_right(p) : {1n + _ == 1n + p : Nat}
      {==}

def L.mul_distrib(x, y, z):
  match x:
    case 0n:
      {==}
    case 1n+p:
      +p = p
      +y = y
      +z = z
      %Equal.sym(Nat, S.mul(p + y, z), S.mul(p, z) + S.mul(y, z),
                 L.mul_distrib(p, y, z)) : {z + _ == (z + S.mul(p, z)) + S.mul(y, z) : Nat}
      %Policy.add_reassoc(z, S.mul(p, z), S.mul(y, z)) : {_ == (z + S.mul(p, z)) + S.mul(y, z) : Nat}
      {==}
