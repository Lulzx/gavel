import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `key_select` descends on both keys at once, so `key_select(a, a, x, y)` is
# stuck on a variable `a`: this one is inductive in `a`, and the step finds its
# two key arguments already equal on the way down. The statement is the
# direction the rewrite below needs -- the right-hand side is the term to be
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
# query. `1n + k` is a cons whatever `k` is, so the match on the first key steps
# and hands the second key its own match; the step is the same fact at `k`'s
# predecessor, and the empty case is the second match finding `0n` against a
# cons.
def Policy.key_select_succ(k: Nat, -x: Nat, -y: Nat) ->
    {y == P.key_select(1n + k, k, x, y) : Nat}:
  match k:
    case 0n:
      {==}
    case 1n+q:
      %Policy.key_select_succ(q, x, y) : {y == _ : Nat}
      {==}

# The match steps on `Nil{}`, so both sides are `0n`.
def L.lookup_nil(k):
  {==}

# `assoc_lookup` steps on the cons cell, so both sides are the same `key_select`.
def L.lookup_cons(hk, hv, kvs, k):
  {==}

# The goal is `key_select(k, k, v, assoc_lookup(kvs, k)) == v`, which the
# comparison's reflexivity settles without looking at the tail.
def L.lookup_hit(v, kvs, k):
  %Policy.key_select_self(k, v, S.assoc_lookup(kvs, k)) : {_ == v : Nat}
  {==}

# The goal is `key_select(1n + k, k, v, assoc_lookup(kvs, k)) == assoc_lookup(kvs, k)`,
# which the comparison's successor case settles the same way.
def L.lookup_skip(v, kvs, k):
  %Policy.key_select_succ(k, v, S.assoc_lookup(kvs, k)) :
      {_ == S.assoc_lookup(kvs, k) : Nat}
  {==}
