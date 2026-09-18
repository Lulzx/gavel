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

# Definitional: the match on `Nil{}` adds nothing.
def L.sum_dec2_nil():
  {==}

def L.sum_dec2_snoc(xs, x):
  match xs:
    case Nil{}:
      # Both sides are `dec2(x)`; the left carries a trailing `+ 0n`.
      %Policy.add_zero(P.dec2(x)) : {P.dec2(x) + 0n == _ : Nat}
      {==}
    case h <> t:
      # The hypothesis has `sum_dec2(append(t, x <> Nil{}))` on the left, which is
      # where the goal has it too, so it is flipped before it is applied. What
      # is left is the head's contribution in the middle of a sum, which has to
      # come out to the front.
      %Equal.sym(Nat, S.sum_dec2(P.append(t, x <> Nil{})), S.sum_dec2(t) + P.dec2(x), L.sum_dec2_snoc(t, x)) : {P.dec2(h) + _ == (P.dec2(h) + S.sum_dec2(t)) + P.dec2(x) : Nat}
      %Policy.add_assoc(P.dec2(h), S.sum_dec2(t), P.dec2(x)) : {P.dec2(h) + (S.sum_dec2(t) + P.dec2(x)) == _ : Nat}
      {==}
