import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

def L.map_len_nil():
  {==}

def L.map_len_cons(l, t):
  {==}

def L.longest_row_nil():
  {==}

def L.longest_row_cons(l, t):
  {==}

# Inductive in `xss`. The step: the goal after unfolding is `max(len(l),
# longest_row(t))` against `max(len(l), max_list(map_len(t)))`, so the hypothesis
# at the tail sits under the `max` the first row contributes, and the two sides
# are the same term once it has been used. The motive is written in that unfolded
# shape because that is where the hypothesis's right-hand side ends up.
def L.longest_row_map_len(xss):
  match xss:
    case Nil{}:
      {==}
    case l <> t:
      %L.longest_row_map_len(t) : {P.max(P.len(l), S.longest_row(t)) == P.max(P.len(l), _) : Nat}
      {==}
