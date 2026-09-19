import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `+` is stuck on a variable, so neither adding zero on the right nor
# reassociating is definitional, and the snoc law's proof needs both. `b` and
# `c` in the second lemma are erased: they appear only in the statement, never
# in the computation, which keeps the induction variable to a single live use.
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

# `count_if` steps on the list, so the empty list answers `0n` without looking
# at anything.
def L.count_if_nil():
  {==}

# Definitional: the record's contribution is `P.same` of its two halves, which
# both sides name.
def L.count_if_cons(a, b, t):
  {==}

# Inductive in the list. The empty case leaves `same(a, b) + 0n` against
# `same(a, b)`, which is associativity-free but still needs zero on the right to
# drop; the step case leaves the head's contribution in the middle of a sum,
# which has to come out to the front.
def L.count_if_snoc(ps, a, b):
  match ps:
    case Nil{}:
      %Policy.add_zero(P.same(a, b)) : {P.same(a, b) + 0n == _ : Nat}
      {==}
    case P.MkPair{c, d} <> t:
      # The hypothesis has `count_if(append(t, ...))` on the left, which is where
      # the goal has it too, so it is flipped before it is applied.
      %Equal.sym(Nat, S.count_if(P.append(t, P.MkPair{a, b} <> Nil{})), S.count_if(t) + P.same(a, b), L.count_if_snoc(t, a, b)) : {P.same(c, d) + _ == (P.same(c, d) + S.count_if(t)) + P.same(a, b) : Nat}
      %Policy.add_assoc(P.same(c, d), S.count_if(t), P.same(a, b)) : {P.same(c, d) + (S.count_if(t) + P.same(a, b)) == _ : Nat}
      {==}
