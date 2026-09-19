import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

def L.del_min_nil():
  {==}

def L.del_min_single(x):
  {==}

def L.del_min_keep(x, y, t, e):
  %Equal.sym(Bool, P.le(x, P.min_go(y <> t, y)), True{}, e)
      : {P.dm_dec(x, y, t, S.del_min(y <> t), _) == y <> t : List<&2, Nat>}
  {==}

def L.del_min_drop(x, y, t, e):
  %Equal.sym(Bool, P.le(x, P.min_go(y <> t, y)), False{}, e)
      : {P.dm_dec(x, y, t, S.del_min(y <> t), _) == x <> S.del_min(y <> t) : List<&2, Nat>}
  {==}

def Policy.dm_dec_len(+h: Nat, +h2: Nat, +t2: List<&2, Nat>, +r: List<&2, Nat>, k: Bool,
                      +e: {P.len(r) == P.len(t2) : Nat})
    -> {1n + P.len(t2) == P.len(P.dm_dec(h, h2, t2, r, k)) : Nat}:
  match k:
    case True{}:
      {==}
    case False{}:
      %e : {1n + _ == 1n + P.len(r) : Nat}
      {==}

def Policy.del_min_len_gen(+t: List<&2, Nat>, +h: Nat)
    -> {P.len(S.del_min(h <> t)) == P.len(t) : Nat}:
  match t:
    case Nil{}:
      {==}
    case +h2 <> t2:
      %Policy.dm_dec_len(h, h2, t2, S.del_min(h2 <> t2), P.le(h, P.min_go(h2 <> t2, h2)),
                         Policy.del_min_len_gen(t2, h2))
          : {_ == P.len(h2 <> t2) : Nat}
      {==}

def L.del_min_len(h, t):
  Policy.del_min_len_gen(t, h)
