import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The match steps on `Nil{}`, so both sides are `Nil{}`.
def L.values_nil():
  {==}

# `values` steps on the cons cell and reads the value, so both sides are the
# same term.
def L.values_cons(hk, hv, kvs):
  {==}

# `assoc_put` reduces to a cons cell and `values` reads its value, so both sides
# are the same term.
def L.values_put(kvs, k, v):
  {==}

# The match steps on `Nil{}`, so both sides are `0n`.
def L.sum_values_nil():
  {==}

# `sum_values` steps on the cons cell and adds its value, so both sides are the
# same term.
def L.sum_values_cons(hk, hv, kvs):
  {==}

# Inductive in `kvs`. The step reduces to `hv + sum_values(t)` against
# `hv + nsum(values(t))`, which is the hypothesis at the tail.
def L.sum_values_values(kvs):
  match kvs:
    case Nil{}:
      {==}
    case P.Mk{hk, hv} <> t:
      %L.sum_values_values(t) : {hv + S.sum_values(t) == hv + _ : Nat}
      {==}
