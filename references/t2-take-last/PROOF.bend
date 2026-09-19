import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `P.le(0n, k)` answers `True{}` in both cases of `k`, but neither case is
# reachable while `k` is a variable, so the comparison does not reduce: this is
# the step that shows it, one successor at a time. The statement is oriented with
# `True{}` on the left because a rewrite step replaces the side the hole in the
# pattern stands for.
def Policy.le_zero_left(k: Nat) -> {True{} == P.le(0n, k) : Bool}:
  match k:
    case 0n:
      {==}
    case 1n+p:
      {==}

# The premise of `take_last_long`, turned around so that it can be used: a
# hypothesis can only be spent through a rewrite, and a rewrite replaces the side
# of the equation the hole in the pattern stands for, so what the law needs is
# `True{} == P.le(...)` and not the other way round.
def Policy.le_flip(xs: List<&2, Nat>, k: Nat, e: {P.le(P.len(xs), k) == True{} : Bool}) -> {True{} == P.le(P.len(xs), k) : Bool}:
  %e : {_ == P.le(P.len(xs), k) : Bool}
  {==}

# `Nil{}` is the outer match's first case, on both sides.
def L.take_last_nil(k):
  {==}

# Both sides reduce to the same `P.keep_if` on the same comparison, the same pair
# and the same walk on the same `k`.
def L.take_last_step(h, t, k):
  {==}

# One element is short enough for every positive count, which is the fact that
# `P.le(0n, k)` holds and does not reduce at a variable `k`: the lemma steps the
# count one successor at a time until the comparison answers.
def L.take_last_single(x, k):
  %Policy.le_zero_left(k) :
      {P.keep_if(_, x <> Nil{}, S.take_last(Nil{}, 1n + k)) == x <> Nil{} : List<&2, Nat>}
  {==}

# The walk over a variable list is stuck, so the two sides are not the same
# unfolding. At a cons the length against `0n` answers `False{}` on the spot, so
# the step drops the head and leaves the walk over the tail, which is the
# hypothesis.
def L.take_last_zero(xs):
  match xs:
    case Nil{}:
      {==}
    case +h <> +t:
      %L.take_last_zero(t) : {S.take_last(t, 0n) == _ : List<&2, Nat>}
      {==}

# The premise is about the input, so the case split is all this needs: at `Nil{}`
# the two sides are the same list, and at a cons the premise is exactly the
# comparison the step is decided by, which is what turns `P.keep_if` into the
# list it was given.
def L.take_last_long(xs, k, e):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Policy.le_flip(h <> t, k, e) :
          {P.keep_if(_, h <> t, S.take_last(t, k)) == h <> t : List<&2, Nat>}
      {==}

# Both sides are closed: the count is short enough at once, and the same three
# cells are left on either side.
def L.take_last_three():
  {==}

# Both sides are closed: every cell is dropped and the empty list is all that is
# left.
def L.take_last_all():
  {==}
