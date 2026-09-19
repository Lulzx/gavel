import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The list is the literal `Nil{}`, so the match takes its empty case and the
# answer is the empty list whatever `n` is: both sides are `Nil{}`.
def L.replicate_each_nil(n):
  {==}

# The count in the law is the literal `0n`, so `P.rep` has nothing to copy and
# the case split is on the list. At `Nil{}` both sides are already the empty
# list. At a cons the head's copies are the empty list, attaching the empty list
# in front of the tail's answer in `P.append` cannot change it, and what is left
# is the tail's own answer -- which the hypothesis replaces with the empty list.
def L.replicate_each_zero(xs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %L.replicate_each_zero(t) : {S.replicate_each(t, 0n) == _ : List<&2, Nat>}
      {==}

# The list is a cons, so the match takes the cons case: the head's copies are put
# in front of the tail's, with the same `n`. Both sides are that same term.
def L.replicate_each_cons(n, x, t):
  {==}

# The count in the law is the literal `1n`, so `P.rep` copies one element once
# and the case split is on the list. At `Nil{}` both sides are already the empty
# list. At a cons the head's copies are the head on its own, attaching one
# element in front of the tail's answer is the cons the right-hand side has, and
# what is left is the tail's answer -- which the hypothesis replaces with the
# tail itself.
def L.replicate_each_one(xs):
  match xs:
    case Nil{}:
      {==}
    case +h <> +t:
      %L.replicate_each_one(t) : {h <> S.replicate_each(t, 1n) == h <> _ : List<&2, Nat>}
      {==}

# Every term is closed, so every match reduces: the copies of `1n` are two, the
# copies of `2n` are two, and what is left is `[1n, 1n, 2n, 2n]` against itself.
def L.replicate_each_two():
  {==}
