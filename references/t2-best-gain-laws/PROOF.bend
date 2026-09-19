import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `best_gain` takes the empty case of its own match, so both sides are `0n` by
# unfolding alone.
def L.best_gain_nil():
  {==}

# `x <> Nil{}` is a cons cell whose tail is empty, so the step reduces to the
# prelude's rise over nothing and the target's own call on the empty list; both
# are `0n`, and `Nat.max` of two equal arguments computes to that value.
def L.best_gain_single(x):
  {==}

# The step of the definition written out, with both sides reducing to the same
# `Nat.max` of the prelude's rise and the tail's own gain.
def L.best_gain_cons(h, t):
  {==}

# Helper lemmas. `Policy.` is the reserved namespace: the gate ignores it and
# the credit path does not count it, but none of them may cite a law.

# `Nat.max(a, 0n)` is `a`: the floor the subtraction already puts under every
# rise cannot lower it further. The statement is oriented with `a` on the left
# because a rewrite step replaces the *right* side of its equation by the left,
# and `a` is what the goal has to end up with. On a successor the prelude's
# comparison against `0n` is decided by the constructor alone, so the case
# closes by computation without the hypothesis.
def Policy.max_zero(a: Nat) -> {a == Nat.max(a, 0n) : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+q:
      {==}

# The pair is the head's rise into a one-element tail; the tail's own gain is
# zero, and the head's rise is already floored by the truncated subtraction, so
# the `Nat.max` the step leaves behind is the `max` against `0n` that the lemma
# above removes. The first step rewrites the inner term and the second the outer
# one, leaving `Nat.sub(b, a)` against itself.
def L.best_gain_pair(a, b):
  %Policy.max_zero(Nat.sub(b, a)) : {Nat.max(_, 0n) == Nat.sub(b, a) : Nat}
  %Policy.max_zero(Nat.sub(b, a)) : {_ == Nat.sub(b, a) : Nat}
  {==}
