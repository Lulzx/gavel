import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

def L.snoc_each_nil(y):
  {==}

def L.snoc_each_cons(l, y, t):
  {==}

def L.front_each_nil(y):
  {==}

def L.front_each_cons(l, y, t):
  {==}

# Inductive in `xss`. The step: appending to a row and putting an element in
# front of it are both unfolds on the same rows, and the goal after unfolding
# has `y` on the front and `z` on the end of the first row on both sides. The
# hypothesis at the tail is the whole of what is left. The motive is written in
# the unfolded shape because that is where the hypothesis's right-hand side
# sits: the two sides of the step are the same term only after `snoc` has taken
# the head of the row apart.
def L.snoc_front_commute(xss, y, z):
  match xss:
    case Nil{}:
      {==}
    case l <> t:
      %L.snoc_front_commute(t, y, z) : {(y <> P.snoc(l, z)) <> S.snoc_each(S.front_each(t, y), z) == (y <> P.snoc(l, z)) <> _ : List<&2, List<&2, Nat>>}
      {==}
