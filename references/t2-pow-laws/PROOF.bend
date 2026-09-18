import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

def Policy.mul_one_right(x: Nat) -> {Nat.mul(x, 1n) == x : Nat}:
  match x:
    case 0n:
      {==}
    case 1n+p:
      %Policy.mul_one_right(p) : {1n + Nat.mul(p, 1n) == 1n + _ : Nat}
      {==}

def L.pow_zero(x):
  {==}

def L.pow_one(x):
  %Policy.mul_one_right(x) : {Nat.mul(x, 1n) == _ : Nat}
  {==}

# Definitional: the exponent is a successor, so the match takes the step case
# and the local `+x = a` binding makes the two sides identical.
def L.pow_succ(x, p):
  {==}
