import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The generalized statement. The law below is an induction on the list, and its
# step case leaves the hypothesis at the default the law was stated with, which
# is not where the goal has got to: the head of the list became the default on
# the way down. Carrying `d` as a parameter is what makes the hypothesis land at
# `a`. `xs` is `+` because the tail is live twice in the step, once as the
# recursive call the hypothesis replaces and once in what is left of the goal.
def Policy.last_snoc_general(+xs: List<&2, Nat>, h: Nat, d: Nat)
    -> {S.last(P.snoc(xs, h), d) == h : Nat}:
  match xs:
    case Nil{}:
      {==}
    case a <> b:
      %Policy.last_snoc_general(b, h, a) : {S.last(P.snoc(b, h), a) == _ : Nat}
      {==}

def L.last_nil(d):
  {==}

def L.last_cons(h, t, d):
  {==}

def L.last_snoc(xs, h, d):
  %Policy.last_snoc_general(xs, h, d) : {S.last(P.snoc(xs, h), d) == _ : Nat}
  {==}
