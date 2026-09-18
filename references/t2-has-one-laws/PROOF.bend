import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `or` is stuck on a variable, so `or(b, False{})` does not reduce: this one
# is inductive in `b`. `or` matches on its first argument, so the `True{}`
# case finds its answer without looking at the second.
def Policy.or_false(b: Bool) -> {Bool.or(b, False{}) == b : Bool}:
  match b:
    case False{}:
      {==}
    case True{}:
      {==}

# `or` is associative. `or` matches on its first argument, so with a variable
# `a` the left-hand side is stuck: this one is inductive in `a`. The other two
# binders are erased: they appear only in the statement, never in the
# computation, which keeps the induction variable to a single live use.
def Policy.or_assoc(a: Bool, -b: Bool, -c: Bool) ->
    {Bool.or(a, Bool.or(b, c)) == Bool.or(Bool.or(a, b), c) : Bool}:
  match a:
    case False{}:
      {==}
    case True{}:
      {==}

# `or` on a one-element list: the head's test ors into `has_one(Nil{})`.
def L.has_one_nil():
  {==}

def L.has_one_snoc(xs, x):
  match xs:
    case Nil{}:
      # Both sides are `is_one_b(x)`; the left carries a trailing
      # `or _ False{}`.
      %Policy.or_false(P.is_one_b(x)) : {Bool.or(P.is_one_b(x), False{}) == _ : Bool}
      {==}
    case h <> t:
      # The hypothesis has `has_one(append(t, x <> Nil{}))` on the left,
      # which is where the goal has it too, so it is flipped before it is
      # applied. What is left is the head's test in the middle of a disjunction,
      # which has to come out to the front.
      %Equal.sym(Bool, S.has_one(P.append(t, x <> Nil{})), Bool.or(S.has_one(t), P.is_one_b(x)), L.has_one_snoc(t, x)) : {Bool.or(P.is_one_b(h), _) == Bool.or(Bool.or(P.is_one_b(h), S.has_one(t)), P.is_one_b(x)) : Bool}
      %Policy.or_assoc(P.is_one_b(h), S.has_one(t), P.is_one_b(x)) : {Bool.or(P.is_one_b(h), Bool.or(S.has_one(t), P.is_one_b(x))) == _ : Bool}
      {==}
