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

def Policy.mul_zero_right(x: Nat) -> {x * 0n == 0n : Nat}:
  match x:
    case 0n:
      {==}
    case 1n+p:
      %Equal.sym(Nat, p * 0n, 0n, Policy.mul_zero_right(p)) : {_ == 0n : Nat}
      {==}

def Policy.mul_succ_right(x: Nat, +y: Nat) -> {x * (1n + y) == x + x * y : Nat}:
  match x:
    case 0n:
      {==}
    case 1n+p:
      +p = p
      %Equal.sym(Nat, p * (1n + y), p + p * y, Policy.mul_succ_right(p, y)) :
          {(1n + y) + _ == (1n + p) + (y + p * y) : Nat}
      %Equal.sym(Nat, y + (p + p * y), (y + p) + p * y,
                 Policy.add_assoc(y, p, p * y)) :
          {1n + _ == 1n + (p + (y + p * y)) : Nat}
      %Equal.sym(Nat, y + p, p + y, Policy.add_comm(y, p)) :
          {1n + (_ + p * y) == 1n + (p + (y + p * y)) : Nat}
      %Policy.add_assoc(p, y, p * y) : {1n + _ == 1n + (p + (y + p * y)) : Nat}
      {==}

def Policy.mul_comm(a: Nat, +b: Nat) -> {a * b == b * a : Nat}:
  match a:
    case 0n:
      %Equal.sym(Nat, b * 0n, 0n, Policy.mul_zero_right(b)) : {0n == _ : Nat}
      {==}
    case 1n+p:
      +p = p
      +b = b
      %Equal.sym(Nat, p * b, b * p, Policy.mul_comm(p, b)) : {b + _ == b * (1n + p) : Nat}
      %Equal.sym(Nat, b * (1n + p), b + b * p, Policy.mul_succ_right(b, p)) :
          {b + b * p == _ : Nat}
      {==}

def Policy.sum_to_double_add(n: Nat) -> {S.sum_to(n) + S.sum_to(n) == n * (1n + n) : Nat}:
  match n:
    case 0n:
      {==}
    case 1n+p:
      +p = p
      %Equal.sym(Nat, (1n + p) * (1n + (1n + p)), (1n + p) + (1n + p) * (1n + p),
                 Policy.mul_succ_right(1n + p, 1n + p)) :
          {(S.sum_to(p) + (1n + p)) + (S.sum_to(p) + (1n + p)) == _ : Nat}
      %Equal.sym(Nat, (1n + p) * (1n + p), (1n + p) + (1n + p) * p,
                 Policy.mul_succ_right(1n + p, p)) :
          {(S.sum_to(p) + (1n + p)) + (S.sum_to(p) + (1n + p)) == (1n + p) + _ : Nat}
      %Equal.sym(Nat, (1n + p) + ((1n + p) + (1n + p) * p), ((1n + p) + (1n + p)) + (1n + p) * p,
                 Policy.add_assoc(1n + p, 1n + p, (1n + p) * p)) :
          {(S.sum_to(p) + (1n + p)) + (S.sum_to(p) + (1n + p)) == _ : Nat}
      %Equal.sym(Nat, (1n + p) * p, p * (1n + p), Policy.mul_comm(1n + p, p)) :
          {(S.sum_to(p) + (1n + p)) + (S.sum_to(p) + (1n + p)) == ((1n + p) + (1n + p)) + _ : Nat}
      %Policy.add_assoc(S.sum_to(p), 1n + p, S.sum_to(p) + (1n + p)) :
          {_ == ((1n + p) + (1n + p)) + p * (1n + p) : Nat}
      %Equal.sym(Nat, (1n + p) + (S.sum_to(p) + (1n + p)), ((1n + p) + S.sum_to(p)) + (1n + p),
                 Policy.add_assoc(1n + p, S.sum_to(p), 1n + p)) :
          {S.sum_to(p) + _ == ((1n + p) + (1n + p)) + p * (1n + p) : Nat}
      %Equal.sym(Nat, (1n + p) + S.sum_to(p), S.sum_to(p) + (1n + p),
                 Policy.add_comm(1n + p, S.sum_to(p))) :
          {S.sum_to(p) + (_ + (1n + p)) == ((1n + p) + (1n + p)) + p * (1n + p) : Nat}
      %Policy.add_assoc(S.sum_to(p), 1n + p, 1n + p) :
          {S.sum_to(p) + _ == ((1n + p) + (1n + p)) + p * (1n + p) : Nat}
      %Equal.sym(Nat, S.sum_to(p) + (S.sum_to(p) + ((1n + p) + (1n + p))),
                 (S.sum_to(p) + S.sum_to(p)) + ((1n + p) + (1n + p)),
                 Policy.add_assoc(S.sum_to(p), S.sum_to(p), (1n + p) + (1n + p))) :
          {_ == ((1n + p) + (1n + p)) + p * (1n + p) : Nat}
      %Equal.sym(Nat, S.sum_to(p) + S.sum_to(p), p * (1n + p),
                 Policy.sum_to_double_add(p)) :
          {_ + ((1n + p) + (1n + p)) == ((1n + p) + (1n + p)) + p * (1n + p) : Nat}
      %Policy.add_comm(p * (1n + p), (1n + p) + (1n + p)) :
          {p * (1n + p) + ((1n + p) + (1n + p)) == _ : Nat}
      {==}

def Policy.two_mul(x: Nat) -> {2n * x == x + x : Nat}:
  %Policy.add_zero_right(x) : {x + _ == x + x : Nat}
  {==}

def L.sum_to_zero():
  {==}

def L.sum_to_succ(p):
  {==}

def L.sum_to_double(n):
  +n = n
  %Equal.sym(Nat, 2n * S.sum_to(n), S.sum_to(n) + S.sum_to(n), Policy.two_mul(S.sum_to(n))) :
      {_ == n * (1n + n) : Nat}
  %Equal.sym(Nat, S.sum_to(n) + S.sum_to(n), n * (1n + n), Policy.sum_to_double_add(n)) :
      {_ == n * (1n + n) : Nat}
  {==}
