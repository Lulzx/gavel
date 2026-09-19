import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `0n` is the literal the match on the stride stops on, so the answer is the
# empty list without the list being looked at.
def L.take_every_nth_zero(xs):
  {==}

# An induction on the count. `0n` answers without looking at the list, and
# `1n + p` opens the walk on the empty list, whose own empty case answers
# `Nil{}` as well. The list is not the argument the match consumes here, so
# there is no case split on it.
def L.take_every_nth_nil(n):
  match n:
    case 0n:
      {==}
    case 1n+p:
      {==}

# A stride of `1n` is the walk opened with no skip owed, so the two sides are
# the walk's answer at the tail against the tail. The walk's own definition
# steps on the list, and at a variable list the step is stuck, so this is an
# induction on the list: the hypothesis says the same fact one element along,
# turned round so that the rewrite can replace the walk's answer with the tail.
def L.take_every_nth_one(xs):
  match xs:
    case Nil{}:
      {==}
    case h <> +t:
      %Equal.sym(List<&2, Nat>, S.take_every_nth(1n, t), t, L.take_every_nth_one(t)) : {h <> _ == h <> t : List<&2, Nat>}
      {==}

# Both sides open the walk at the same skip count on the same list: the stride
# `1n + n` is one plus the skip count `n`, and `take_every_nth` hands the walk
# the list with nothing owed.
def L.take_every_nth_step(n, xs):
  {==}

# `Nil{}` is the walk's first case, whatever the skip count and the debt are.
def L.every_nth_go_nil(m, i):
  {==}

# Nothing is owed, so the element in hand is kept and the tail is walked with
# the gap restarted at `m`. Both sides are the same cons cell in front of the
# same call.
def L.every_nth_go_take(m, h, t):
  {==}

# One skip is owed, so the element in hand is passed over and the debt goes down
# by one. Both sides are the same call on the same tail.
def L.every_nth_go_skip(m, h, t, k):
  {==}

# Both sides are closed, so every match steps: the walk keeps the first, third
# and fifth element and passes over the two between each pair.
def L.take_every_nth_five():
  {==}

# The same at a stride of three, where the last gap does not complete before the
# list ends: the walk keeps `1n` and `4n` and `7n` and answers the empty list
# after the seventh.
def L.take_every_nth_seven():
  {==}
