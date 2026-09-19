import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `key_select` descends on both keys at once, so `key_select(a, a, x, y)` is
# stuck on a variable `a`: this one is inductive in `a`, and the step finds its
# two key arguments already equal on the way down. The statement is the
# direction the rewrites below need -- the right-hand side is the term to be
# replaced -- and `x` and `y` are erased because they appear only in it.
def Policy.key_select_self(a: Nat, -x: List<&2, P.Entry>, -y: List<&2, P.Entry>) ->
    {x == P.key_select(a, a, x, y) : List<&2, P.Entry>}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.key_select_self(p, x, y) : {x == _ : List<&2, P.Entry>}
      {==}

# The other half of the comparison: a key one more than the query is not the
# query. `1n + k` is a cons whatever `k` is, so the first match steps; the step
# is the same fact at `k`'s predecessor, and the empty case is the second match
# finding `0n` against a cons.
def Policy.key_select_succ(k: Nat, -x: List<&2, P.Entry>, -y: List<&2, P.Entry>) ->
    {y == P.key_select(1n + k, k, x, y) : List<&2, P.Entry>}:
  match k:
    case 0n:
      {==}
    case 1n+q:
      %Policy.key_select_succ(q, x, y) : {y == _ : List<&2, P.Entry>}
      {==}

def L.assoc_delete_nil(k):
  {==}

def L.assoc_delete_step(hk, hv, k, t):
  {==}

def L.assoc_delete_hit(w, kvs, k):
  %Policy.key_select_self(k, kvs, P.Mk{k, w} <> S.assoc_delete(k, kvs)) :
      {_ == kvs : List<&2, P.Entry>}
  {==}

def L.assoc_delete_skip(w, kvs, k):
  %Policy.key_select_succ(k, kvs, P.Mk{1n + k, w} <> S.assoc_delete(k, kvs)) :
      {_ == P.Mk{1n + k, w} <> S.assoc_delete(k, kvs) : List<&2, P.Entry>}
  {==}
