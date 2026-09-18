import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

def Policy.add_zero_right(a: Nat) -> {a == a + 0n : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_zero_right(p) : {1n + p == 1n + _ : Nat}
      {==}

def Policy.add_assoc(a: Nat, -b: Nat, -c: Nat) -> {a + (b + c) == (a + b) + c : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_assoc(p, b, c) : {1n + (p + (b + c)) == 1n + _ : Nat}
      {==}

def Policy.add_succ_right(a: Nat, -b: Nat) -> {a + (1n + b) == 1n + (a + b) : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_succ_right(p, b) : {1n + (p + (1n + b)) == 1n + _ : Nat}
      {==}

def Policy.add_comm(a: Nat, +b: Nat) -> {a + b == b + a : Nat}:
  match a:
    case 0n:
      %Policy.add_zero_right(b) : {b == _ : Nat}
      {==}
    case 1n+p:
      +p = p
      %Equal.sym(Nat, b + (1n + p), 1n + (b + p), Policy.add_succ_right(b, p)) :
          {1n + (p + b) == _ : Nat}
      %Policy.add_comm(p, b) : {1n + (p + b) == 1n + _ : Nat}
      {==}

def Policy.mul_zero_right(x: Nat) -> {S.mul(x, 0n) == 0n : Nat}:
  match x:
    case 0n:
      {==}
    case 1n+p:
      %Equal.sym(Nat, S.mul(p, 0n), 0n, Policy.mul_zero_right(p)) : {_ == 0n : Nat}
      {==}

def Policy.mul_succ_right(x: Nat, +y: Nat) -> {S.mul(x, 1n + y) == x + S.mul(x, y) : Nat}:
  match x:
    case 0n:
      {==}
    case 1n+p:
      +p = p
      %Equal.sym(Nat, S.mul(p, 1n + y), p + S.mul(p, y), Policy.mul_succ_right(p, y)) :
          {(1n + y) + _ == (1n + p) + (y + S.mul(p, y)) : Nat}
      %Equal.sym(Nat, y + (p + S.mul(p, y)), (y + p) + S.mul(p, y),
                 Policy.add_assoc(y, p, S.mul(p, y))) :
          {1n + _ == 1n + (p + (y + S.mul(p, y))) : Nat}
      %Equal.sym(Nat, y + p, p + y, Policy.add_comm(y, p)) : {1n + (_ + S.mul(p, y)) == 1n + (p + (y + S.mul(p, y))) : Nat}
      %Policy.add_assoc(p, y, S.mul(p, y)) : {1n + _ == 1n + (p + (y + S.mul(p, y))) : Nat}
      {==}

def L.mul_one_right(x):
  match x:
    case 0n:
      {==}
    case 1n+p:
      %Equal.sym(Nat, S.mul(p, 1n), p, L.mul_one_right(p)) : {1n + _ == 1n + p : Nat}
      {==}

def L.mul_zero_right(x):
  match x:
    case 0n:
      {==}
    case 1n+p:
      %Equal.sym(Nat, S.mul(p, 0n), 0n, L.mul_zero_right(p)) : {_ == 0n : Nat}
      {==}

def L.mul_succ_right(x, y):
  match x:
    case 0n:
      {==}
    case 1n+p:
      +p = p
      +y = y
      %Equal.sym(Nat, S.mul(p, 1n + y), p + S.mul(p, y), L.mul_succ_right(p, y)) :
          {(1n + y) + _ == (1n + p) + (y + S.mul(p, y)) : Nat}
      %Equal.sym(Nat, y + (p + S.mul(p, y)), (y + p) + S.mul(p, y),
                 Policy.add_assoc(y, p, S.mul(p, y))) :
          {1n + _ == 1n + (p + (y + S.mul(p, y))) : Nat}
      %Equal.sym(Nat, y + p, p + y, Policy.add_comm(y, p)) : {1n + (_ + S.mul(p, y)) == 1n + (p + (y + S.mul(p, y))) : Nat}
      %Policy.add_assoc(p, y, S.mul(p, y)) : {1n + _ == 1n + (p + (y + S.mul(p, y))) : Nat}
      {==}

def L.mul_comm(a, b):
  match a:
    case 0n:
      %Equal.sym(Nat, S.mul(b, 0n), 0n, Policy.mul_zero_right(b)) : {0n == _ : Nat}
      {==}
    case 1n+p:
      +p = p
      +b = b
      %Equal.sym(Nat, S.mul(p, b), S.mul(b, p), L.mul_comm(p, b)) :
          {b + _ == S.mul(b, 1n + p) : Nat}
      %Equal.sym(Nat, S.mul(b, 1n + p), b + S.mul(b, p), Policy.mul_succ_right(b, p)) :
          {b + S.mul(b, p) == _ : Nat}
      {==}
