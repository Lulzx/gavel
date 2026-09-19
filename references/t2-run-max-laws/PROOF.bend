import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The list is a literal `Nil{}`, so the match takes the empty branch whatever
# the running value is and answers without looking at it.
def L.run_max_nil(m):
  {==}

# `h <> Nil{}` is a cons cell, so the match takes the cons branch, emits
# `P.max(m, h)` and walks the tail, which is `Nil{}` again.
def L.run_max_single(h, m):
  {==}

# Inductive in `xs`. The step case leaves the goal as
# `P.max(m, h) <> run_max(append(t, ys), P.max(m, h))` against
# `P.max(m, h) <> append(run_max(t, P.max(m, h)), run_max(ys, after_max(t, P.max(m, h))))`
# -- the hypothesis at the tail, with the head already folded into the running
# value, is exactly the term sitting after the emitted entry.
def L.run_max_append(xs, ys, m):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %L.run_max_append(t, ys, P.max(m, h)) : {P.max(m, h) <> S.run_max(P.append(t, ys), P.max(m, h)) == P.max(m, h) <> _ : List<Nat>}
      {==}
