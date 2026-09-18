import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `and` is stuck on a variable, so `and(b, True{})` does not reduce: this one
# is inductive in `b`. `and` matches on its first argument, so the `False{}`
# case finds its answer without looking at the second.
def Policy.and_true(b: Bool) -> {Bool.and(b, True{}) == b : Bool}:
  match b:
    case False{}:
      {==}
    case True{}:
      {==}

# `and` is associative. `and` matches on its first argument, so with a variable
# `a` the left-hand side is stuck: this one is inductive in `a`. The other two
# binders are erased: they appear only in the statement, never in the
# computation, which keeps the induction variable to a single live use.
def Policy.and_assoc(a: Bool, -b: Bool, -c: Bool) ->
    {Bool.and(a, Bool.and(b, c)) == Bool.and(Bool.and(a, b), c) : Bool}:
  match a:
    case False{}:
      {==}
    case True{}:
      {==}

# `and` on a one-element list: the head's test ands into `all_mult3(Nil{})`.
def L.all_mult3_nil():
  {==}

def L.all_mult3_snoc(xs, x):
  match xs:
    case Nil{}:
      # Both sides are `is_mult3_b(x)`; the left carries a trailing
      # `and _ True{}`.
      %Policy.and_true(P.is_mult3_b(x)) : {Bool.and(P.is_mult3_b(x), True{}) == _ : Bool}
      {==}
    case h <> t:
      # The hypothesis has `all_mult3(append(t, x <> Nil{}))` on the left, which is
      # where the goal has it too, so it is flipped before it is applied. What
      # is left is the head's test in the middle of a conjunction, which has to come
      # out to the front.
      %Equal.sym(Bool, S.all_mult3(P.append(t, x <> Nil{})), Bool.and(S.all_mult3(t), P.is_mult3_b(x)), L.all_mult3_snoc(t, x)) : {Bool.and(P.is_mult3_b(h), _) == Bool.and(Bool.and(P.is_mult3_b(h), S.all_mult3(t)), P.is_mult3_b(x)) : Bool}
      %Policy.and_assoc(P.is_mult3_b(h), S.all_mult3(t), P.is_mult3_b(x)) : {Bool.and(P.is_mult3_b(h), Bool.and(S.all_mult3(t), P.is_mult3_b(x))) == _ : Bool}
      {==}
