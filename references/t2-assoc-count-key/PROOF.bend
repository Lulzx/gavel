import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `key_select` descends on both keys at once, so `key_select(a, a, x, y)` is
# stuck on a variable `a`: this one is inductive in `a`. The statement is the
# direction the rewrites below need -- the right-hand side is the term to be
# replaced -- and `x` and `y` are erased because they appear only in it.
def Policy.key_select_self(a: Nat, -x: Nat, -y: Nat) ->
    {x == P.key_select(a, a, x, y) : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.key_select_self(p, x, y) : {x == _ : Nat}
      {==}

# The other half of the comparison: a key one more than the query is not the
# query. `1n + k` is a cons whatever `k` is, so the first match steps; the step
# is the same fact at `k`'s predecessor, and the empty case is the second match
# finding `0n` against a cons.
def Policy.key_select_succ(k: Nat, -x: Nat, -y: Nat) ->
    {y == P.key_select(1n + k, k, x, y) : Nat}:
  match k:
    case 0n:
      {==}
    case 1n+q:
      %Policy.key_select_succ(q, x, y) : {y == _ : Nat}
      {==}

def L.count_key_nil(k):
  {==}

def L.count_key_cons(hk, hv, kvs, k):
  {==}

def L.count_key_hit(v, kvs, k):
  %Policy.key_select_self(k, 1n + S.count_key(kvs, k), S.count_key(kvs, k)) :
      {_ == 1n + S.count_key(kvs, k) : Nat}
  {==}

def L.count_key_skip(v, kvs, k):
  %Policy.key_select_succ(k, 1n + S.count_key(kvs, k), S.count_key(kvs, k)) :
      {_ == S.count_key(kvs, k) : Nat}
  {==}

def L.count_key_put(kvs, k, v):
  %Policy.key_select_self(k, 1n + S.count_key(kvs, k), S.count_key(kvs, k)) :
      {_ == 1n + S.count_key(kvs, k) : Nat}
  {==}
