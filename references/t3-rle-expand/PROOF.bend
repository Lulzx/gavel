import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

def Policy.add_assoc(a: Nat, -b: Nat, -c: Nat) -> {a + (b + c) == (a + b) + c : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_assoc(p, b, c) : {1n + (p + (b + c)) == 1n + _ : Nat}
      {==}

def Policy.len_append(+xs: List<&2, Nat>, +ys: List<&2, Nat>)
    -> {P.len(P.append(xs, ys)) == P.len(xs) + P.len(ys) : Nat}:
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Equal.sym(Nat, P.len(P.append(t, ys)), P.len(t) + P.len(ys),
                 Policy.len_append(t, ys)) : {1n + _ == (1n + P.len(t)) + P.len(ys) : Nat}
      %Equal.sym(Nat, 1n + (P.len(t) + P.len(ys)), (1n + P.len(t)) + P.len(ys),
                 Policy.add_assoc(1n, P.len(t), P.len(ys))) : {_ == (1n + P.len(t)) + P.len(ys) : Nat}
      {==}

def Policy.len_repeat(x: Nat, k: Nat) -> {P.len(P.repeat(x, k)) == k : Nat}:
  match k:
    case 0n:
      {==}
    case 1n++p:
      %Equal.sym(Nat, P.len(P.repeat(x, p)), p,
                 Policy.len_repeat(x, p)) : {1n + _ == 1n + p : Nat}
      {==}

def Policy.expand_len(rs: List<&2, P.Run>) -> {P.len(S.expand(rs)) == P.sum_k(rs) : Nat}:
  match rs:
    case Nil{}:
      {==}
    case P.Mk{+v, +k} <> +t:
      %Equal.sym(Nat, P.len(P.append(P.repeat(v, k), S.expand(t))),
                 P.len(P.repeat(v, k)) + P.len(S.expand(t)),
                 Policy.len_append(P.repeat(v, k), S.expand(t)))
          : {_ == k + P.sum_k(t) : Nat}
      %Equal.sym(Nat, P.len(P.repeat(v, k)), k,
                 Policy.len_repeat(v, k)) : {_ + P.len(S.expand(t)) == k + P.sum_k(t) : Nat}
      %Equal.sym(Nat, P.len(S.expand(t)), P.sum_k(t),
                 Policy.expand_len(t)) : {k + _ == k + P.sum_k(t) : Nat}
      {==}

def L.expand_nil():
  {==}

def L.expand_cons(v, k, t):
  {==}

def L.expand_len(rs):
  %Policy.expand_len(rs) : {P.len(S.expand(rs)) == _ : Nat}
  {==}
