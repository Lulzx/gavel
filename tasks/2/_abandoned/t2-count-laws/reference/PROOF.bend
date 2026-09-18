import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `+` is stuck on a variable, so neither adding zero on the right nor
# reassociating is definitional, and the proof needs both. `b` and `c` in the
# second lemma are erased: they appear only in the statement, never in the
# computation, which keeps the induction variable to a single live use.
def Policy.add_zero(x: Nat) -> {x + 0n == x : Nat}:
  match x:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_zero(p) : {1n + (p + 0n) == 1n + _ : Nat}
      {==}

def Policy.add_assoc(a: Nat, -b: Nat, -c: Nat) -> {a + (b + c) == (a + b) + c : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_assoc(p, b, c) : {1n + (p + (b + c)) == 1n + _ : Nat}
      {==}

# Definitional: the match on `Nil{}` counts nothing.
def L.count_nil(n):
  {==}

def L.count_snoc(xs, x, n):
  match xs:
    case Nil{}:
      # Both sides are `eq(x, n)`; the left carries a trailing `+ 0n`.
      %Policy.add_zero(P.eq(x, n)) : {P.eq(x, n) + 0n == _ : Nat}
      {==}
    case h <> t:
      # Both steps below use `n`, and each use consumes the binder, so it is
      # re-bound reusable before it is used twice.
      +k = n
      # The hypothesis has `count(append(t, x <> Nil{}), k)` on the left, which
      # is where the goal has it too, so it is flipped before it is applied.
      # What is left is the head's contribution in the middle of a sum, which
      # has to come out to the front.
      %Equal.sym(Nat, S.count(P.append(t, x <> Nil{}), k), S.count(t, k) + P.eq(x, k), L.count_snoc(t, x, k)) : {P.eq(h, k) + _ == (P.eq(h, k) + S.count(t, k)) + P.eq(x, k) : Nat}
      %Policy.add_assoc(P.eq(h, k), S.count(t, k), P.eq(x, k)) : {P.eq(h, k) + (S.count(t, k) + P.eq(x, k)) == _ : Nat}
      {==}
