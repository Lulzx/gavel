import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The three facts about `Bool` the inductions below need. None of them is in the
# prelude, and none may be a law: a law that cited one would make an isolated
# law depend on a law that has not been credited yet and the credit for both
# would be lost. `not` matches on its argument, and `and` and `or` match on
# their first argument, so a case split on that one argument is the whole proof
# of each: the second binder is never inspected, which is why it is erased.

def Policy.not_not(b: Bool) -> {b == Bool.not(Bool.not(b)) : Bool}:
  match b:
    case False{}:
      {==}
    case True{}:
      {==}

# The de Morgan direction the `all` law needs: the negation of a disjunction is
# the conjunction of the negations. `or` matches on its first argument, so
# splitting on `a` is enough -- with `a` a constructor both sides compute, and
# `b` is never looked at.
def Policy.not_or(a: Bool, -b: Bool) ->
    {Bool.not(Bool.or(a, b)) == Bool.and(Bool.not(a), Bool.not(b)) : Bool}:
  match a:
    case False{}:
      {==}
    case True{}:
      {==}

# The other direction, for the `any` law. Same shape: `and` matches on its
# first argument, so the case split on `a` exposes both sides as values.
def Policy.not_and(a: Bool, -b: Bool) ->
    {Bool.not(Bool.and(a, b)) == Bool.or(Bool.not(a), Bool.not(b)) : Bool}:
  match a:
    case False{}:
      {==}
    case True{}:
      {==}

# The two definitions are the unfolding of `neg_all` at a constructor. They fix
# the shape of the answer: without them a body that put the negated elements in
# the wrong order would satisfy everything below.
def L.neg_all_nil():
  {==}

def L.neg_all_cons(h, t):
  {==}

# Negating twice is the identity. The step unfolds the outer `neg_all` onto a
# cons, which leaves `Bool.not(Bool.not(h))` as the head of the left-hand side
# and the doubly-negated tail inside it. The head comes out first, with the
# double-negation helper, because `not` on a variable is stuck and nothing else
# can move it; then the hypothesis on the tail finishes the cell. `xs` is `+`
# because the step uses the tail inside the goal and again as the hypothesis's
# argument.
def L.neg_all_involutive(xs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Policy.not_not(h) : {_ <> S.neg_all(S.neg_all(t)) == h <> t : List<&2, Bool>}
      %Equal.sym(List<&2, Bool>, S.neg_all(S.neg_all(t)), t, L.neg_all_involutive(t)) :
          {h <> _ == h <> t : List<&2, Bool>}
      {==}

# `all` of the negations is the negation of `any`. The step unfolds both sides
# into `Bool.and(Bool.not(h), _)` and `Bool.not(Bool.or(h, _))`. The hole the
# hypothesis fills is the second argument of a conjunction whose first argument
# is the already-computed `Bool.not(h)`, which is why the ordering matters:
# `and` matches on that first argument, so with `h` a variable it does not
# reduce and the motive can only reach the second position. Once the hypothesis
# has replaced the tail's fold by the negation of the other fold, the two sides
# are the two halves of de Morgan and nothing about the list is left -- the
# helper for that fact is what closes the cell.
def L.neg_all_all(xs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Equal.sym(Bool, P.all_bool(S.neg_all(t)), Bool.not(P.any_bool(t)), L.neg_all_all(t)) :
          {Bool.and(Bool.not(h), _) == Bool.not(Bool.or(h, P.any_bool(t))) : Bool}
      %Policy.not_or(h, P.any_bool(t)) : {_ == Bool.not(Bool.or(h, P.any_bool(t))) : Bool}
      {==}

# The dual law. Same step, the other way round: the fold that reduces is `or`
# and the de Morgan fact runs from a conjunction to a disjunction, so this law
# needs the helper the `all` law did not use. A policy that proved one of the
# two and guessed the other direction at the other law finds the goal stuck.
def L.neg_all_any(xs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Equal.sym(Bool, P.any_bool(S.neg_all(t)), Bool.not(P.all_bool(t)), L.neg_all_any(t)) :
          {Bool.or(Bool.not(h), _) == Bool.not(Bool.and(h, P.all_bool(t))) : Bool}
      %Policy.not_and(h, P.all_bool(t)) : {_ == Bool.not(Bool.and(h, P.all_bool(t))) : Bool}
      {==}
