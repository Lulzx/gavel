import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

def L.nondesc_run_nil():
  {==}

def L.nondesc_run_single(x):
  {==}

def L.nondesc_run_up(x, y, t, e):
  %Equal.sym(Bool, P.le(x, y), True{}, e) : {P.rl_put(_, S.nondesc_run(y <> t)) == 1n + S.nondesc_run(y <> t) : Nat}
  {==}

def L.nondesc_run_down(x, y, t, e):
  %Equal.sym(Bool, P.le(x, y), False{}, e) : {P.rl_put(_, S.nondesc_run(y <> t)) == 1n : Nat}
  {==}

def Policy.rl_le(+n: Nat, +m: Nat, k: Bool, +e: {P.le(n, m) == True{} : Bool})
    -> {P.le(P.rl_put(k, n), 1n + m) == True{} : Bool}:
  match k:
    case True{}:
      %e : {P.le(n, m) == _ : Bool}
      {==}
    case False{}:
      {==}

def Policy.run_le_len_gen(+t: List<&2, Nat>, x: Nat)
    -> {P.le(S.nondesc_run(x <> t), P.len(x <> t)) == True{} : Bool}:
  match t:
    case Nil{}:
      {==}
    case +y <> +t2:
      %Policy.rl_le(S.nondesc_run(y <> t2), P.len(y <> t2), P.le(x, y), Policy.run_le_len_gen(t2, y))
          : {P.le(S.nondesc_run(x <> y <> t2), P.len(x <> y <> t2)) == _ : Bool}
      {==}

def L.nondesc_run_le_len(x, t):
  Policy.run_le_len_gen(t, x)
