import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The four facts about `+` the induction needs. None is in the prelude, and none
# may be a law: a law that cited one would make an isolated law depend on a law
# that has not been credited yet and the credit for both would be lost. Each is
# stuck on a variable -- `Nat.add` matches on its *left* argument -- so each is
# an induction of its own. The `-` on a parameter says each step uses it only in
# the goal.
def Policy.add_zero_right(a: Nat) -> {a + 0n == a : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Equal.sym(Nat, p + 0n, p, Policy.add_zero_right(p)) : {1n + _ == 1n + p : Nat}
      {==}

def Policy.add_succ_right(b: Nat, -p: Nat) -> {b + (1n + p) == 1n + (b + p) : Nat}:
  match b:
    case 0n:
      {==}
    case 1n+q:
      %Equal.sym(Nat, q + (1n + p), 1n + (q + p), Policy.add_succ_right(q, p)) :
          {1n + _ == 1n + (1n + (q + p)) : Nat}
      {==}

def Policy.add_assoc(a: Nat, -b: Nat, -c: Nat) -> {a + (b + c) == (a + b) + c : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_assoc(p, b, c) : {1n + (p + (b + c)) == 1n + _ : Nat}
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

# The induction the law needs. It is not a generalization of the law -- the law
# is already stated over a free `xs` -- but it is an induction, and the step is
# the whole task. `xs` is `+` because the tail is live twice in the step, once
# for each of the two `S.split(t)` the goal calls `len` on.
def Policy.split_len_induction(+xs: List<&2, Nat>)
    -> {P.len(P.evens(S.split(xs))) + P.len(P.odds(S.split(xs))) == P.len(xs) : Nat}:
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      # The goal after unfolding is `1n + (A + B) == 1n + len(t)` with `A` the
      # odd half's length and `B` the even half's, and the hypothesis is
      # `B + A == len(t)`. The two lengths have to be swapped before the
      # hypothesis can be used at all, which is the `add_comm` below.
      %Equal.sym(Nat, P.len(P.odds(S.split(t))) + P.len(P.evens(S.split(t))),
                 P.len(P.evens(S.split(t))) + P.len(P.odds(S.split(t))),
                 Policy.add_comm(P.len(P.odds(S.split(t))), P.len(P.evens(S.split(t))))) :
          {1n + _ == 1n + P.len(t) : Nat}
      %Equal.sym(Nat, P.len(P.evens(S.split(t))) + P.len(P.odds(S.split(t))), P.len(t),
                 Policy.split_len_induction(t)) : {1n + _ == 1n + P.len(t) : Nat}
      {==}

def L.split_nil():
  {==}

# The two sides are the same term, so this closes on its own. It is worth
# stating because it is what says the split alternates: it is the only law that
# mentions both projections of the same recursive call.
def L.split_cons(h, t):
  {==}

def L.split_len(xs):
  %Policy.split_len_induction(xs) :
      {P.len(P.evens(S.split(xs))) + P.len(P.odds(S.split(xs))) == _ : Nat}
  {==}
