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

# `sub(a, 0n)` reduces as soon as `a` is constructor-headed, so this is a case
# analysis rather than an induction: matching on `a` is the whole proof.
def Policy.sub_zero_right(a: Nat) -> {P.sub(a, 0n) == a : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      {==}

def Policy.sub_self(a: Nat) -> {P.sub(a, a) == 0n : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Equal.sym(Nat, P.sub(p, p), 0n, Policy.sub_self(p)) : {_ == 0n : Nat}
      {==}

def L.absdiff_zero_left(b):
  match b:
    case 0n:
      {==}
    case 1n+q:
      {==}

def L.absdiff_zero_right(a):
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_zero_right(1n + p) : {_ == 1n + p : Nat}
      {==}

def L.absdiff_self(a):
  match a:
    case 0n:
      {==}
    case 1n+p:
      +p = p
      %Equal.sym(Nat, P.sub(p, p), 0n, Policy.sub_self(p)) : {_ + P.sub(p, p) == 0n : Nat}
      %Equal.sym(Nat, P.sub(p, p), 0n, Policy.sub_self(p)) : {_ == 0n : Nat}
      {==}

def L.absdiff_comm(a, b):
  +a = a
  +b = b
  %Policy.add_comm(P.sub(a, b), P.sub(b, a)) : {P.sub(a, b) + P.sub(b, a) == _ : Nat}
  {==}
