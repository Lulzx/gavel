import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The three facts about `+` the interaction law's step needs. None is in the
# prelude, and none may be a law: a law that cited one would make an isolated law
# depend on a law that has not been credited yet and the credit for both would be
# lost. Each is stuck on a variable -- `+` matches on its *left* argument -- so
# each is an induction of its own. The `-` on a parameter says its step uses it
# only in the goal.
def Policy.add_assoc(a: Nat, -b: Nat, -c: Nat) -> {a + (b + c) == (a + b) + c : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_assoc(p, b, c) : {1n + (p + (b + c)) == 1n + _ : Nat}
      {==}

def Policy.add_succ_right(b: Nat, -p: Nat) -> {b + (1n + p) == 1n + (b + p) : Nat}:
  match b:
    case 0n:
      {==}
    case 1n+q:
      %Equal.sym(Nat, q + (1n + p), 1n + (q + p), Policy.add_succ_right(q, p)) :
          {1n + _ == 1n + (1n + (q + p)) : Nat}
      {==}

def Policy.add_zero_right(a: Nat) -> {a + 0n == a : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Equal.sym(Nat, p + 0n, p, Policy.add_zero_right(p)) : {1n + _ == 1n + p : Nat}
      {==}

def Policy.add_comm(a: Nat, +b: Nat) -> {a + b == b + a : Nat}:
  match a:
    case 0n:
      %Equal.sym(Nat, b + 0n, b, Policy.add_zero_right(b)) : {b == _ : Nat}
      {==}
    case 1n+p:
      %Equal.sym(Nat, b + (1n + p), 1n + (b + p), Policy.add_succ_right(b, p)) :
          {1n + (p + b) == _ : Nat}
      %Equal.sym(Nat, p + b, b + p, Policy.add_comm(p, b)) : {1n + _ == 1n + (b + p) : Nat}
      {==}

def L.swap_each_nil():
  {==}

def L.swap_each_cons(a, b, t):
  {==}

def L.sum_pair_nil():
  {==}

def L.sum_pair_cons(a, b, t):
  {==}

# Inductive in `ps`. The step: the goal after unfolding is `MkPair{a, b}` in
# front of the doubly swapped tail against `MkPair{a, b}` in front of the tail,
# so the hypothesis at the tail is the whole of what is left.
def L.swap_each_swap_each(ps):
  match ps:
    case Nil{}:
      {==}
    case P.MkPair{a, b} <> t:
      %L.swap_each_swap_each(t) : {P.MkPair{a, b} <> S.swap_each(S.swap_each(t)) == P.MkPair{a, b} <> _ : List<&2, P.Pair>}
      {==}

# Inductive in `ps`. The step after unfolding is `b + (a + s)` against
# `a + (b + s)` with `s` the sum of the tail: the hypothesis replaces the inner
# sum, and what is left is the two halves of one record in the other order, which
# is commutativity of `+` read through associativity on both sides.
def L.sum_pair_swap_each(ps):
  match ps:
    case Nil{}:
      {==}
    case P.MkPair{a, b} <> t:
      %Equal.sym(Nat, S.sum_pair(S.swap_each(t)), S.sum_pair(t), L.sum_pair_swap_each(t)) :
          {b + (a + _) == a + (b + S.sum_pair(t)) : Nat}
      %Equal.sym(Nat, b + (a + S.sum_pair(t)), (b + a) + S.sum_pair(t), Policy.add_assoc(b, a, S.sum_pair(t))) :
          {_ == a + (b + S.sum_pair(t)) : Nat}
      %Equal.sym(Nat, a + (b + S.sum_pair(t)), (a + b) + S.sum_pair(t), Policy.add_assoc(a, b, S.sum_pair(t))) :
          {(b + a) + S.sum_pair(t) == _ : Nat}
      %Policy.add_comm(a, b) : {_ + S.sum_pair(t) == (a + b) + S.sum_pair(t) : Nat}
      {==}
