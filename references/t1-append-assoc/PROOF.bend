import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The first argument here is the literal `Nil{}`, so `append` reduces on it and
# the goal is `xs == xs`.
def L.append_nil_left(xs):
  {==}

# `append` matches on its first argument, so with a variable `xs` on the left
# the goal does not reduce on its own: this one is inductive, and the induction
# hypothesis rewrites the right-hand side into the left.
def L.append_nil(xs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %L.append_nil(t) : {h <> S.append(t, Nil{}) == h <> _ : List<Nat>}
      {==}

# Both sides of the step reduce to a cons cell in front of the two tails, and
# the induction hypothesis matches those tails exactly.
def L.append_assoc(xs, ys, zs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %L.append_assoc(t, ys, zs) : {h <> S.append(S.append(t, ys), zs) == h <> _ : List<Nat>}
      {==}
