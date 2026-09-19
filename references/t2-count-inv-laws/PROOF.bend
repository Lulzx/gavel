import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `count_inv` takes the empty case of its own match, so both sides are `0n` by
# unfolding alone.
def L.count_inv_nil():
  {==}

# `x <> Nil{}` is a cons cell, and the prelude's count over the empty tail is
# `0n`, so both sides compute.
def L.count_inv_single(x):
  {==}

# The step of the definition written out, with both sides reducing to the
# prelude's count plus the tail's own count.
def L.count_inv_cons(h, t):
  {==}

# Helper lemmas. `Policy.` is the reserved namespace: the gate ignores it and
# the credit path does not count it, but none of them may cite a law.

# `P.is_lt` steps one successor off each side at once, so `P.is_lt(a, a)` is
# stuck on a variable `a` and its being zero is a fact about `a` rather than an
# unfolding. The statement is oriented with `0n` on the left because a rewrite
# step replaces the *right* side of its equation by the left, and `0n` is what
# the goal has to end up with.
def Policy.is_lt_refl(a: Nat) -> {0n == P.is_lt(a, a) : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.is_lt_refl(p) : {0n == _ : Nat}
      {==}

# Nothing in a run of copies is strictly below the element it is a copy of, so
# the prelude's count over `P.replicate(n, a)` is zero. The induction is on `n`:
# the cons case leaves `P.is_lt(a, a)` in front of the count over the shorter
# run, which the reflexivity lemma above turns into `0n`, and the rest is the
# hypothesis.
def Policy.count_gt_replicate(n: Nat, +a: Nat) -> {0n == P.count_gt(a, P.replicate(n, a)) : Nat}:
  match n:
    case 0n:
      {==}
    case 1n++k:
      %Policy.is_lt_refl(a) : {0n == _ + P.count_gt(a, P.replicate(k, a)) : Nat}
      %Policy.count_gt_replicate(k, a) : {0n == _ : Nat}
      {==}

# The run of copies is a cons cell in front of a shorter run, so the step leaves
# the prelude's count over that shorter run in front of the induction's own
# subject. The count is zero by the lemma above, and the shorter run's count is
# zero by the hypothesis, which is the second rewrite; the `Equal.sym` is there
# because the law states its equation with the target's call on the left and a
# rewrite step wants the answer on the left.
def L.count_inv_replicate(n, a):
  match n:
    case 0n:
      {==}
    case 1n++k:
      %Policy.count_gt_replicate(k, a) : {_ + S.count_inv(P.replicate(k, a)) == 0n : Nat}
      %Equal.sym(Nat, S.count_inv(P.replicate(k, a)), 0n, L.count_inv_replicate(k, a)) : {_ == 0n : Nat}
      {==}
