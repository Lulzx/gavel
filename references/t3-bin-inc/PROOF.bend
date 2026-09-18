import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

def Policy.add_succ_right(b: Nat, -p: Nat) -> {b + (1n + p) == 1n + (b + p) : Nat}:
  match b:
    case 0n:
      {==}
    case 1n+q:
      %Equal.sym(Nat, q + (1n + p), 1n + (q + p), Policy.add_succ_right(q, p)) :
          {1n + _ == 1n + (1n + (q + p)) : Nat}
      {==}

def Policy.to_nat_inc_general(+bs: List<&2, P.Bit>) -> {P.to_nat(S.inc_bin(bs)) == 1n + P.to_nat(bs) : Nat}:
  match bs:
    case Nil{}:
      {==}
    case h <> t:
      match h:
        case P.O{}:
          {==}
        case P.I{}:
          %Equal.sym(Nat, P.to_nat(S.inc_bin(t)), 1n + P.to_nat(t), Policy.to_nat_inc_general(t)) :
              {_ + P.to_nat(S.inc_bin(t)) == 2n + (P.to_nat(t) + P.to_nat(t)) : Nat}
          %Equal.sym(Nat, P.to_nat(S.inc_bin(t)), 1n + P.to_nat(t), Policy.to_nat_inc_general(t)) :
              {(1n + P.to_nat(t)) + _ == 2n + (P.to_nat(t) + P.to_nat(t)) : Nat}
          %Equal.sym(Nat, P.to_nat(t) + (1n + P.to_nat(t)), 1n + (P.to_nat(t) + P.to_nat(t)), Policy.add_succ_right(P.to_nat(t), P.to_nat(t))) :
              {1n + _ == 2n + (P.to_nat(t) + P.to_nat(t)) : Nat}
          {==}

def L.inc_bin_nil():
  {==}

def L.inc_bin_zero(t):
  {==}

def L.to_nat_inc(bs):
  %Policy.to_nat_inc_general(bs) : {P.to_nat(S.inc_bin(bs)) == _ : Nat}
  {==}
