import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

def L.fact_zero():
  {==}

# Definitional: the argument is a successor, so the match takes the step arm and
# binds the predecessor back as `n`, making the two sides the same term.
def L.fact_succ(n):
  {==}

def L.facts_nil():
  {==}

# Definitional: `x <> xs` is a cons cell, so the match takes the step arm.
def L.facts_cons(x, xs):
  {==}

# The one law that is not the reference's own unfolding. Both sides are stuck on
# the variable `xs`, so the induction is the only way through: the empty case is
# the two base cases, and the step case needs the hypothesis to turn
# `P.len(S.facts(xs))` into `P.len(xs)`.
def L.facts_len(xs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %L.facts_len(t) : {1n + P.len(S.facts(t)) == 1n + _ : Nat}
      {==}
