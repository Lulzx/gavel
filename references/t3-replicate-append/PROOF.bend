import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# Helpers. `Policy.` is the reserved namespace: the gate ignores it, so helpers
# are free -- but none of them may cite a law.

# `snoc` on the right of a run is one more copy of `x`. `snoc` matches on its
# first argument, so with a variable run the goal is stuck: the step unfolds
# `replicate` on the successor count and the induction hypothesis carries the
# tail. This is the fact `rev_replicate` cannot get by computation.
def Policy.replicate_snoc(n: Nat, +x: Nat) -> {S.replicate(1n + n, x) == P.snoc(S.replicate(n, x), x) : List<Nat>}:
  match n:
    case 0n:
      {==}
    case 1n+p:
      %Equal.sym(List<Nat>, S.replicate(1n + p, x), P.snoc(S.replicate(p, x), x), Policy.replicate_snoc(p, x)) : {x <> _ == x <> P.snoc(S.replicate(p, x), x) : List<Nat>}
      {==}

# Reversing a run leaves it unchanged. A cons run reverses into a `snoc` of the
# shorter run, so the step first collapses the reversal by the induction
# hypothesis and then folds the `snoc` back into a run with `replicate_snoc` --
# leaving a definitional equality. `x` is used by both steps and `p` by both
# calls, so the helper takes `+x` and its successor binder is `+p`; the law's own
# binder is a bare name, which is why this induction lives here.
def Policy.rev_replicate(n: Nat, +x: Nat) -> {P.rev(S.replicate(n, x)) == S.replicate(n, x) : List<Nat>}:
  match n:
    case 0n:
      {==}
    case 1n++p:
      %Equal.sym(List<Nat>, P.rev(S.replicate(p, x)), S.replicate(p, x), Policy.rev_replicate(p, x)) : {P.snoc(_, x) == x <> S.replicate(p, x) : List<Nat>}
      %Policy.replicate_snoc(p, x) : {_ == x <> S.replicate(p, x) : List<Nat>}
      {==}

# `len` folds over `replicate`, which is one turn away from a cons: the step
# exposes a `1n +` on both sides and the induction hypothesis replaces the tail.
def L.replicate_len(n, x):
  match n:
    case 0n:
      {==}
    case 1n+p:
      %Equal.sym(Nat, P.len(S.replicate(p, x)), p, L.replicate_len(p, x)) : {1n + _ == 1n + p : Nat}
      {==}

# The second count is a parameter of the induction: the left-hand side unfolds
# because a successor-added count still reduces, `1n + (p + m)`, and `append`
# splits the cons on the right.
def L.replicate_append(n, m, x):
  match n:
    case 0n:
      {==}
    case 1n+p:
      %Equal.sym(List<Nat>, S.replicate(p + m, x), P.append(S.replicate(p, x), S.replicate(m, x)), L.replicate_append(p, m, x)) : {x <> _ == x <> P.append(S.replicate(p, x), S.replicate(m, x)) : List<Nat>}
      {==}

# One copy of `x` is a literal count, so both sides compute to `x <> Nil{}`.
def L.replicate_single(x):
  {==}

# The law is the helper: the helper's statement is exactly this one, so the law
# is a single call and the rewrite closes the remaining definitional equality.
def L.rev_replicate(n, x):
  %Policy.rev_replicate(n, x) : {P.rev(S.replicate(n, x)) == _ : List<Nat>}
  {==}
