import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The input is the literal `Nil{}`, which is the first case of the match, so
# both sides reduce by unfolding alone.
def L.distinct_nil():
  {==}

# `h <> t` is a cons cell, so the outer match takes its cons case and hands the
# tail to the walk with the head as the one element already seen.
def L.distinct_cons(h, t):
  {==}

# The walk's empty case: nothing is left to keep, whatever has been seen.
def L.distinct_go_nil(seen):
  {==}

# The walk's cons case: the head is tested against the seen set and either left
# out or kept in front of the rest of the walk, which carries the head into the
# set it recurses with.
def L.distinct_go_step(h, t, seen):
  {==}

# `eq` steps one successor off both of its arguments at once, so with the
# argument it is handed twice it never gets off the ground: `eq(k, k)` is stuck
# where it is written, and this is the lemma that says it is `True{}` there. It
# is under the reserved `Policy.*` namespace because it is about the prelude's
# comparison rather than about the policy.
def Policy.eq_refl(k: Nat) -> {P.eq(k, k) == True{} : Bool}:
  match k:
    case 0n:
      {==}
    case 1n+p:
      %Policy.eq_refl(p) : {P.eq(p, p) == _ : Bool}
      {==}

# A set whose head is `k` holds `k`, whatever else is in it: the test on a hit
# is `True{}` without asking the tail. This is the lemma the walk's step needs
# whenever the element under test is one it has just carried in, and it is about
# the prelude's membership test rather than about the policy.
def Policy.mem_head(seen: List<&2, Nat>, k: Nat) -> {P.mem(k <> seen, k) == True{} : Bool}:
  %Equal.sym(Bool, P.eq(k, k), True{}, Policy.eq_refl(k)) : {P.or_if(_, P.mem(seen, k)) == True{} : Bool}
  {==}

# A walk over `n` copies of `k`, from a set that already holds `k`: the empty
# list, because every one of them is a duplicate of something seen before.
# Inductive in `n`. Each element is a hit -- `mem_head` -- so the decision
# unfolds to its first answer and the element contributes nothing; what is left
# is the hypothesis at the predecessor, with the element one deeper in the set
# the walk recurses with.
#
# Both the element and the set are rebound reusable first (`+r = k`, `+s =
# seen`): a proof def's parameters are good for one live use each, and each of
# these is cited by a lemma, by the hypothesis, or both. The rebound names carry
# those uses instead, so `k` and `seen` themselves are read once.
def L.distinct_same_seen(n, k, seen):
  match n:
    case 0n:
      {==}
    case 1n+p:
      +r = k
      +s = seen
      %Equal.sym(Bool, P.mem(r <> s, r), True{}, Policy.mem_head(s, r)) : {P.skip_if(_, r, S.distinct_go(P.same(p, r), r <> (r <> s))) == Nil{} : List<Nat>}
      %Equal.sym(List<Nat>, S.distinct_go(P.same(p, r), r <> (r <> s)), Nil{}, L.distinct_same_seen(p, r, r <> s)) : {P.skip_if(True{}, r, _) == Nil{} : List<Nat>}
      {==}

# A list headed by `k` with `m` more copies of `k` behind it: the one element.
# The head is kept without a test, and the walk it hands the tail to starts with
# `k` already seen, so every copy behind it is a hit and the hypothesis above at
# `p` closes the step -- the set the walk recurses with there is `k <> Nil{}`,
# which still holds `k`. No induction of its own: the list of equal elements is
# the law above's subject, and this one only puts a head in front of it.
def L.distinct_same(m, k):
  match m:
    case 0n:
      {==}
    case 1n+p:
      +r = k
      %Equal.sym(Bool, P.mem(r <> Nil{}, r), True{}, Policy.mem_head(Nil{}, r)) : {r <> P.skip_if(_, r, S.distinct_go(P.same(p, r), r <> (r <> Nil{}))) == r <> Nil{} : List<Nat>}
      %Equal.sym(List<Nat>, S.distinct_go(P.same(p, r), r <> (r <> Nil{})), Nil{}, L.distinct_same_seen(p, r, r <> Nil{})) : {r <> P.skip_if(True{}, r, _) == r <> Nil{} : List<Nat>}
      {==}

# Both sides are closed, and `mem` is decided at every step: `1n` is kept, `2n`
# is kept, and the second `1n` is a hit against the `1n` already in the set, so
# it is left out and what is left is `[1n, 2n]` against `[1n, 2n]`.
def L.distinct_nonadjacent():
  {==}
