import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `assoc_put` does not walk the list, so both sides are the same cons.
def L.put_cons(kvs, k, v):
  {==}

# The match steps on `Nil{}`, so both sides are `Nil{}`.
def L.keys_nil():
  {==}

# `keys` steps on the cons cell, so both sides are the same term.
def L.keys_cons(hk, hv, kvs):
  {==}

# `assoc_put` reduces to a cons cell and `keys` reads its head, so both sides
# are the same term.
def L.keys_put(kvs, k, v):
  {==}

# Inductive in `kvs`. The step reduces to `1n + len(keys(t))` against
# `1n + plen(t)`, which is the hypothesis at the tail.
def L.keys_len(kvs):
  match kvs:
    case Nil{}:
      {==}
    case P.Mk{hk, hv} <> t:
      %L.keys_len(t) : {1n + P.len(S.keys(t)) == 1n + _ : Nat}
      {==}
