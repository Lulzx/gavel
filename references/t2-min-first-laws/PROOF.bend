import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

def L.min_first_nil():
  {==}

def L.min_first_single(x):
  {==}

def L.min_first_cons(h, t):
  {==}

def L.min_first_keep(x, y, e):
  %Equal.sym(Bool, P.le(x, y), True{}, e) : {P.mf_dec(x, y, Nil{}, _) == x <> y <> Nil{} : List<&2, Nat>}
  {==}

def L.min_first_swap(x, y, e):
  %Equal.sym(Bool, P.le(x, y), False{}, e) : {P.mf_dec(x, y, Nil{}, _) == y <> x <> Nil{} : List<&2, Nat>}
  {==}

def Policy.mf_len(+h: Nat, +m: Nat, +rest: List<&2, Nat>, k: Bool)
    -> {P.len(P.mf_dec(h, m, rest, k)) == 1n + (1n + P.len(rest)) : Nat}:
  match k:
    case True{}:
      {==}
    case False{}:
      {==}

def Policy.mf_put_len(+h: Nat, +r: List<&2, Nat>) -> {P.len(P.mf_put(h, r)) == 1n + P.len(r) : Nat}:
  match r:
    case Nil{}:
      {==}
    case +m <> rest:
      Policy.mf_len(h, m, rest, P.le(h, m))

def L.min_first_len(xs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Equal.sym(Nat, P.len(P.mf_put(h, S.min_first(t))), 1n + P.len(S.min_first(t)),
                 Policy.mf_put_len(h, S.min_first(t))) : {_ == 1n + P.len(t) : Nat}
      %L.min_first_len(t) : {1n + P.len(S.min_first(t)) == 1n + _ : Nat}
      {==}
