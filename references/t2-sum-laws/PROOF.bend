import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `sum_single` unfolds to `h + 0n`, and `+` is stuck on a variable, so the proof
# needs the fact that adding zero on the right is the identity.
def Policy.add_zero(x: Nat) -> {x + 0n == x : Nat}:
  match x:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_zero(p) : {1n + (p + 0n) == 1n + _ : Nat}
      {==}

# `sum_append` is inductive in `xs`. The step case has to reassociate `+`: the
# head enters to the right of the two sums, and `+` is stuck on a variable head,
# so that reassociation is proved here as a lemma of its own. `b` and `c` are
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
      # Fold the tail first: `sum(h <> append(t, ys))` is `h + ...`.
      %Equal.sym(Nat, S.sum(S.append(t, ys)), S.sum(t) + S.sum(ys), L.sum_append(t, ys)) : {h + _ == (h + S.sum(t)) + S.sum(ys) : Nat}
      # Then reassociate so that `h` is added on the outside.
      %Policy.add_assoc(h, S.sum(t), S.sum(ys)) : {h + (S.sum(t) + S.sum(ys)) == _ : Nat}
      {==}

# `sum_single` is `sum`'s cons step at `Nil{}`, so the goal is `h + 0n == h`.
def L.sum_single(h):
  %Policy.add_zero(h) : {h + 0n == _ : Nat}
  {==}

# `append` matches its first argument, so the cons step is the body's own
# right-hand side read back.
def L.append_cons(h, t, ys):
  {==}

# The `Nil{}` case of the same match: the body answers `ys` there.
def L.append_nil_left(ys):
  {==}
