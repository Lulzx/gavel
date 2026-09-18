import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: an accumulator with nothing left to add answers the accumulator. Both
# sides compute, so this one is definitional, and it is the weak half: the
# constant body `a` satisfies it, and so does a body that ignores the head. It
# is here to fix the empty case, and what makes the set work is that no body
# satisfies it *and* the step law below.
law sum_acc_nil:
  for a: Nat
  {S.sum_acc(Nil{}, a) == a : Nat}

# LAW: one step of the accumulator. Both sides compute, so this is definitional
# too, and it is the law that says the answer is built by *folding* the head
# into the accumulator: a body that recomputed the sum some other way -- by
# calling itself at `0n` on the tail, or by answering `a + P.sum(xs)` directly
# -- agrees with every value law below and leaves the two sides here
# unconvertible.
law sum_acc_cons:
  for h: Nat
  for t: List<&2, Nat>
  for a: Nat
  {S.sum_acc(h <> t, a) == S.sum_acc(t, a + h) : Nat}

# LAW: the accumulator law, and the statement the task does not ask for. An
# induction on the list that starts from `sum_acc_zero` below does not go
# through: the step case needs the hypothesis at `a + h`, and the hypothesis is
# only available at `0n`. Carrying `a` as a variable all the way through is what
# makes the step land, so this law is stated with `a` free and the law below is
# its instantiation. `a` is `+` because the step uses it twice, once in the goal
# and once in the hypothesis at the new accumulator. The accumulator is on the
# left of the `+` and not on the right, which is the direction that matches the
# step: the fold adds what is already in the accumulator to the head.
law sum_acc_add:
  for +xs: List<&2, Nat>
  for +a: Nat
  {S.sum_acc(xs, a) == a + P.sum(xs) : Nat}

# LAW: the law the task is named for -- an accumulator started at zero is the
# sum. `0n + P.sum(xs)` computes to `P.sum(xs)`, so the instantiation of the law
# above closes it in one step; the work is in proving that law, not this one.
# The accumulator is on the left of the `+` here and not on the right, and that
# is the direction that matches the step: the fold adds the head *after* what is
# already in the accumulator.
law sum_acc_zero:
  for +xs: List<&2, Nat>
  {S.sum_acc(xs, 0n) == P.sum(xs) : Nat}
