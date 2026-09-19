import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `sum` adds the head of a cons cell to the left of the recursive sum, so the
# induction step has to move the head past the two sums. That reassociation is
# not definitional -- `+` is stuck on a variable head -- so it is proved here
# as a lemma of its own, under the reserved Policy.* namespace. `b` and `c` are
# erased: they appear only in the statement, never in the computation, which
# keeps the induction variable to a single live use.
def Policy.add_assoc(a: Nat, -b: Nat, -c: Nat) -> {a + (b + c) == (a + b) + c : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_assoc(p, b, c) : {1n + (p + (b + c)) == 1n + _ : Nat}
      {==}

def L.sum_append(xs, ys):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Equal.sym(Nat, S.sum(S.append(t, ys)), S.sum(t) + S.sum(ys), L.sum_append(t, ys)) : {h + _ == (h + S.sum(t)) + S.sum(ys) : Nat}
      %Policy.add_assoc(h, S.sum(t), S.sum(ys)) : {h + (S.sum(t) + S.sum(ys)) == _ : Nat}
      {==}


# `sum` steps on the cons cell, so both sides reduce to `x + sum(xs)`.
def L.sum_cons(x, xs):
  {==}

# Both are `append`'s own unfolding: the head goes out in front of the recursive
# call, and the empty case answers its second argument outright.
def L.append_cons(h, t, ys):
  {==}

def L.append_nil_left(ys):
  {==}
