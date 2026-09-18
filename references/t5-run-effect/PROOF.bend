import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `Nat.add` matches on its left argument, so the arithmetic facts below are not
# definitional: `a + 0n` is stuck on a variable `a`, and `b + 1n` does not move
# the successor out of the way. Both halves of `run_effect` need those facts,
# because the instruction's contribution arrives on the left of the state and
# has to end up on its right.

def Policy.add_zero_right(a: Nat) -> {a == a + 0n : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_zero_right(p) : {1n + p == 1n + _ : Nat}
      {==}

def Policy.add_succ_right(b: Nat, -p: Nat) -> {b + (1n + p) == 1n + (b + p) : Nat}:
  match b:
    case 0n:
      {==}
    case 1n+q:
      %Equal.sym(Nat, q + (1n + p), 1n + (q + p), Policy.add_succ_right(q, p))
          : {1n + _ == 1n + (1n + (q + p)) : Nat}
      {==}

def Policy.add_assoc(a: Nat, -b: Nat, -c: Nat) -> {a + (b + c) == (a + b) + c : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_assoc(p, b, c) : {1n + (p + (b + c)) == 1n + _ : Nat}
      {==}

# The rotation the step of `run_effect` needs, for the same reason: after the
# induction hypothesis the instruction's contribution sits on the left of the
# state and the state's successor has to be pulled past it.
def Policy.add_swap(a: Nat, +b: Nat, -c: Nat) -> {(a + b) + c == b + (a + c) : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Equal.sym(Nat, b + (1n + (p + c)), 1n + (b + (p + c)), Policy.add_succ_right(b, p + c))
          : {1n + ((p + b) + c) == _ : Nat}
      %Policy.add_swap(p, b, c) : {1n + ((p + b) + c) == 1n + _ : Nat}
      {==}

# `effect` is additive over the prelude's append. The step is one reassociation:
# after the induction hypothesis both sides carry the same two terms, one
# bracketed left and the other right.
def Policy.effect_cat(+p: List<&2, P.Instr>, +q: List<&2, P.Instr>)
    -> {S.effect(P.cat(p, q)) == S.effect(p) + S.effect(q) : Nat}:
  match p:
    case Nil{}:
      {==}
    case P.Inc{} <> t:
      %Equal.sym(Nat, S.effect(P.cat(t, q)), S.effect(t) + S.effect(q),
                 Policy.effect_cat(t, q))
          : {1n + _ == (1n + S.effect(t)) + S.effect(q) : Nat}
      %Policy.add_assoc(1n, S.effect(t), S.effect(q))
          : {1n + (S.effect(t) + S.effect(q)) == _ : Nat}
      {==}
    case P.Add{n} <> t:
      %Equal.sym(Nat, S.effect(P.cat(t, q)), S.effect(t) + S.effect(q),
                 Policy.effect_cat(t, q))
          : {n + _ == (n + S.effect(t)) + S.effect(q) : Nat}
      %Policy.add_assoc(n, S.effect(t), S.effect(q))
          : {n + (S.effect(t) + S.effect(q)) == _ : Nat}
      {==}

# Running a concatenation is running the halves in turn. The step needs no
# arithmetic at all: once `run` has unfolded one instruction on each side, the
# two sides *are* the induction hypothesis, at the state the first instruction
# produced. That state is why the hypothesis has to be taken over an arbitrary
# `s` rather than the one the law starts with.
def Policy.run_cat(+p: List<&2, P.Instr>, +q: List<&2, P.Instr>, +s: Nat)
    -> {S.run(P.cat(p, q), s) == S.run(q, S.run(p, s)) : Nat}:
  match p:
    case Nil{}:
      {==}
    case P.Inc{} <> t:
      %Policy.run_cat(t, q, 1n + s) : {S.run(P.cat(t, q), 1n + s) == _ : Nat}
      {==}
    case P.Add{n} <> t:
      %Policy.run_cat(t, q, n + s) : {S.run(P.cat(t, q), n + s) == _ : Nat}
      {==}

# And the summary is the state. The induction is generalized over `s` for the
# same reason as above: the step has to apply the hypothesis at the state the
# first instruction left, not at the one the law was handed.
def Policy.run_effect(prog: List<&2, P.Instr>, +s: Nat)
    -> {S.run(prog, s) == s + S.effect(prog) : Nat}:
  match prog:
    case Nil{}:
      %Policy.add_zero_right(s) : {s == _ : Nat}
      {==}
    case P.Inc{} <> t:
      %Equal.sym(Nat, S.run(t, 1n + s), (1n + s) + S.effect(t),
                 Policy.run_effect(t, 1n + s))
          : {_ == s + (1n + S.effect(t)) : Nat}
      %Policy.add_swap(1n, s, S.effect(t)) : {(1n + s) + S.effect(t) == _ : Nat}
      {==}
    case P.Add{+n} <> t:
      %Equal.sym(Nat, S.run(t, n + s), (n + s) + S.effect(t),
                 Policy.run_effect(t, n + s))
          : {_ == s + (n + S.effect(t)) : Nat}
      %Policy.add_swap(n, s, S.effect(t)) : {(n + s) + S.effect(t) == _ : Nat}
      {==}

# -- The laws ----------------------------------------------------------------
#
# The four pins are definitional, with one exception: `effect_add` reports
# `n + effect(Nil{})` and `n + 0n` is stuck on a variable, so even a pin needs
# the arithmetic fact.

def L.step_inc(s):
  {==}

def L.step_add(s, n):
  {==}

def L.run_inc(s):
  {==}

def L.run_add(s, n):
  {==}

def L.effect_inc():
  {==}

def L.effect_add(n):
  %Policy.add_zero_right(n) : {_ == n : Nat}
  {==}

def L.run_compose(p1, p2, s):
  Policy.run_cat(p1, p2, s)

def L.effect_hom(p1, p2):
  Policy.effect_cat(p1, p2)

def L.run_effect(prog, s):
  Policy.run_effect(prog, s)
