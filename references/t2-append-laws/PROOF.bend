import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `len_cons` is definitional: `len` steps on the cons cell, so both sides reduce
# to `1n + len(xs)`.
def L.len_cons(x, xs):
  {==}

# `len_append` is inductive in `xs`. The step case has to reassociate `+`: the
# head enters to the right of the two lengths, and `+` is stuck on a variable
# head, so that reassociation is proved here as a lemma of its own, under the
# reserved `Policy.` namespace. `b` and `c` are erased: they appear only in the
# statement, never in the computation, which keeps the induction variable to a
# single live use.
def Policy.add_assoc(a: Nat, -b: Nat, -c: Nat) -> {a + (b + c) == (a + b) + c : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_assoc(p, b, c) : {1n + (p + (b + c)) == 1n + _ : Nat}
      {==}

def L.len_append(xs, ys):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      # Fold the tail first, so that the head is added to a sum of two lengths.
      %Equal.sym(Nat, S.len(S.append(t, ys)), S.len(t) + S.len(ys), L.len_append(t, ys)) : {1n + _ == (1n+S.len(t)) + S.len(ys) : Nat}
      # Then reassociate so that the two lengths are added on the inside.
      %Policy.add_assoc(1n, S.len(t), S.len(ys)) : {1n + (S.len(t) + S.len(ys)) == _ : Nat}
      {==}
