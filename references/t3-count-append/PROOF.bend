import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `is_eq` is reflexive. Both branches are definitional: the step's
# `P.is_eq(1n+p, 1n+p)` unfolds to `P.is_eq(p, p)`, which the induction
# hypothesis has already turned into `1n`.
def Policy.is_eq_refl(x: Nat) -> {P.is_eq(x, x) == 1n : Nat}:
  match x:
    case 0n:
      {==}
    case 1n+p:
      %Policy.is_eq_refl(p) : {P.is_eq(p, p) == _ : Nat}
      {==}

# `a + 0n` is stuck on a variable, so it needs its own induction. Stated the
# other way round (`a == a + 0n`) so the term to eliminate is on the right.
def Policy.add_zero_right(a: Nat) -> {a == a + 0n : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_zero_right(p) : {1n + p == 1n + _ : Nat}
      {==}

# Reassociating `+` needs its own induction too. `b` and `c` are erased -- they
# appear in the statement, never in the computation -- which is what lets a call
# site mention a list tail in an erased position, keeping it to one live use.
def Policy.add_assoc(a: Nat, -b: Nat, -c: Nat) -> {a + (b + c) == (a + b) + c : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_assoc(p, b, c) : {1n + (p + (b + c)) == 1n + _ : Nat}
      {==}

# Both sides unfold: `count` on `Nil{}` is `0n`.
def L.count_nil(x):
  {==}

# Both sides unfold: `count` on a cons is the head's indicator plus the tail.
def L.count_cons(x, h, t):
  {==}

# The left side is `P.is_eq(x, x) + 0n`. Rewrite the indicator to `1n`, then
# eliminate the stuck `1n + 0n`.
def L.count_self(x):
  %Equal.sym(Nat, P.is_eq(x, x), 1n, Policy.is_eq_refl(x)) : {_ + 0n == 1n : Nat}
  %Policy.add_zero_right(1n) : {_ == 1n : Nat}
  {==}

# The induction: `append` is stuck on a variable list. The step rewrites the
# tail with the hypothesis (its single live use of `t`) and then reassociates,
# passing the tail to the erased second parameter of `add_assoc`.
def L.count_append(x, xs, ys):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      +x = x
      %Equal.sym(Nat, S.count(x, P.append(t, ys)), S.count(x, t) + S.count(x, ys), L.count_append(x, t, ys)) : {P.is_eq(x, h) + _ == (P.is_eq(x, h) + S.count(x, t)) + S.count(x, ys) : Nat}
      %Policy.add_assoc(P.is_eq(x, h), S.count(x, t), S.count(x, ys)) : {P.is_eq(x, h) + (S.count(x, t) + S.count(x, ys)) == _ : Nat}
      {==}
