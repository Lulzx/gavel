import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The two facts about `+` that the induction needs. Neither is in the prelude,
# and neither may be a law, since a law that cited one would make an isolated
# law depend on a law that has not been credited yet.
def Policy.add_zero_right(a: Nat) -> {a == a + 0n : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_zero_right(p) : {1n + p == 1n + _ : Nat}
      {==}

def Policy.add_assoc(a: Nat, -b: Nat, -c: Nat) -> {a + (b + c) == (a + b) + c : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_assoc(p, b, c) : {1n + (p + (b + c)) == 1n + _ : Nat}
      {==}

# The generalized statement. The accumulator law as it is written in LAWS.bend
# is an induction on the list, and its step case leaves the hypothesis at the
# *original* accumulator, which is not what the goal needs; carrying `a` as a
# variable all the way through makes the hypothesis land at `a + h` instead.
# `a` is `+` because the step uses it in the goal and in the hypothesis, and
# `xs` is `+` because the tail is live twice in the step.
def Policy.sum_acc_general(+xs: List<&2, Nat>, +a: Nat) -> {S.sum_acc(xs, a) == a + P.sum(xs) : Nat}:
  match xs:
    case Nil{}:
      %Policy.add_zero_right(a) : {a == _ : Nat}
      {==}
    case h <> t:
      %Equal.sym(Nat, S.sum_acc(t, a + h), (a + h) + P.sum(t), Policy.sum_acc_general(t, a + h)) :
          {_ == a + (h + P.sum(t)) : Nat}
      %Policy.add_assoc(a, h, P.sum(t)) : {_ == a + (h + P.sum(t)) : Nat}
      {==}

# The two definitions are the unfolding of `sum_acc` at a constructor. They fix
# the shape of the answer: without them a body that answered `a` everywhere
# would satisfy the two laws below, since `a + P.sum(xs)` with `a` free is not
# reached by any of them.
def L.sum_acc_nil(a):
  {==}

def L.sum_acc_cons(h, t, a):
  {==}

# The accumulator law. Nothing here is definitional: `P.sum` of a cons is stuck
# until it unfolds, and the generalized hypothesis is the only thing that closes
# the step.
def L.sum_acc_add(xs, a):
  %Policy.sum_acc_general(xs, a) : {S.sum_acc(xs, a) == _ : Nat}
  {==}

# The law the task is named for: an accumulator started at zero is the sum.
# `0n + P.sum(xs)` computes to `P.sum(xs)`, so the instantiation closes the goal
# on its own -- but only because the generalized law carries an `a` that this
# one does not, which is the whole reason `sum_acc_add` has to be stated.
def L.sum_acc_zero(xs):
  %Policy.sum_acc_general(xs, 0n) : {S.sum_acc(xs, 0n) == _ : Nat}
  {==}
