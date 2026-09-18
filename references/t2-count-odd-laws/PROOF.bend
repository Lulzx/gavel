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
def L.count_odd_nil():
  {==}

def L.count_odd_snoc(xs, x):
  match xs:
    case Nil{}:
      # Both sides are `is_odd(x)`; the left carries a trailing `+ 0n`.
      %Policy.add_zero(P.is_odd(x)) : {P.is_odd(x) + 0n == _ : Nat}
      {==}
    case h <> t:
      # The hypothesis has `count_odd(append(t, x <> Nil{}))` on the left, which
      # is where the goal has it too, so it is flipped before it is applied.
      # What is left is the head's contribution in the middle of a sum, which
      # has to come out to the front.
      %Equal.sym(Nat, S.count_odd(P.append(t, x <> Nil{})), S.count_odd(t) + P.is_odd(x), L.count_odd_snoc(t, x)) : {P.is_odd(h) + _ == (P.is_odd(h) + S.count_odd(t)) + P.is_odd(x) : Nat}
      %Policy.add_assoc(P.is_odd(h), S.count_odd(t), P.is_odd(x)) : {P.is_odd(h) + (S.count_odd(t) + P.is_odd(x)) == _ : Nat}
      {==}
