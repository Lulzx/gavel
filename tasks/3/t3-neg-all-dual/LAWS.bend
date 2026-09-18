import Base
import ./prelude.bend as P
import ./solution.bend as S

# The laws are stated over `List<&2, Bool>`: the steps of the last three use the
# destructured tail more than once, which is only expressible when the list is
# of a kind a `+` binder is allowed on.

# LAW: negating every element of the empty list is the empty list. Both sides
# compute, so this one is definitional, and it is the weak half: a body that
# dropped everything would satisfy it, and the law below rules that body out.
law neg_all_nil:
  {S.neg_all(Nil{}) == Nil{} : List<&2, Bool>}

# LAW: one step of the map. Both sides compute, so this is definitional too, and
# it is the law that says the negation lands on the *head* and the answer keeps
# the order: a body that negated the tail and appended the head on the right
# agrees with every law below -- negation commutes with the folds, and reversing
# twice is the identity -- and leaves the two sides here unconvertible, because
# the head is a variable and both of its values have to come out right.
law neg_all_cons:
  for h: Bool
  for t: List<&2, Bool>
  {S.neg_all(h <> t) == Bool.not(h) <> S.neg_all(t) : List<&2, Bool>}

# LAW: negating twice is the identity. This is the first law that is not
# definitional: the step unfolds the outer `neg_all` onto a cons, which exposes
# `Bool.not(Bool.not(h))` on the left and the doubly-negated tail inside, and
# neither collapses by itself -- `not` matches on its argument and the argument
# here is a variable, and the tail is the hypothesis applied to a tail but only
# after the head has been dealt with. The law pins the mapping from both ends:
# with the cons law it says the answer is the argument, not just a list of the
# right shape.
law neg_all_involutive:
  for +xs: List<&2, Bool>
  {S.neg_all(S.neg_all(xs)) == xs : List<&2, Bool>}

# LAW: negating a list turns "all" into "not any". This is the law the task is
# about, and it is the one no list induction closes on its own: the step has to
# rewrite the hypothesis inside a conjunction whose first conjunct is already a
# value, and what is left once that is done is a fact about `Bool` -- that the
# negation of a disjunction is the conjunction of the negations -- which is not
# a fact about the list at all and cannot be got at from the list induction.
# It is the law that rules out the constant bodies from both ends: `all_bool` of
# a constant list and `not (any_bool xs)` disagree on a variable `xs`.
law neg_all_all:
  for +xs: List<&2, Bool>
  {P.all_bool(S.neg_all(xs)) == Bool.not(P.any_bool(xs)) : Bool}

# LAW: the same duality the other way round, "any" of the negations is "not
# all". It is not implied by the law above -- the two folds disagree on every
# list that is not constant -- and it is not implied by the cons law either,
# which says nothing about either fold. Its step needs the other de Morgan
# direction, so a policy that has only one of the two facts cannot close both.
law neg_all_any:
  for +xs: List<&2, Bool>
  {P.any_bool(S.neg_all(xs)) == Bool.not(P.all_bool(xs)) : Bool}
