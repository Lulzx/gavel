import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the empty list is below or equal to every list, and the walk ends there
# without looking at the other side. Both sides compute, so this is
# definitional, and it is the absolute anchor: its right-hand side calls no
# target. It is also the weak half -- the constant body `True{}` satisfies it.
law lex_le_nil_left:
  for ys: List<&2, Nat>
  {S.lex_le(Nil{}, ys) == True{} : Bool}

# LAW: no non-empty list is below or equal to the empty one. Definitional, and
# the second absolute anchor: the step law below names its second argument as a
# cons cell, so it never reaches `Nil{}` there, and this is the only law that
# fixes what a list running out on the right answers. The left-hand side is
# ground in its second argument -- a cons cell against `Nil{}` reduces outright,
# whatever the tail is.
law lex_le_nil_right:
  for h: Nat
  for t: List<&2, Nat>
  {S.lex_le(h <> t, Nil{}) == False{} : Bool}

# LAW: the step. Two cons cells are ordered by their heads and then by their
# tails: the answer is `True{}` when the first head is strictly below the second
# one, and otherwise it is the tails' own comparison, which the prelude's `eq`
# gates so that a pair of differing heads of equal size is not read as a tie. It
# is the law that fixes which direction the comparison points -- a body whose
# `P.lt` has its arguments the other way round leaves the two sides apart -- and
# the one the walk's own definition is written out in.
law lex_le_cons:
  for h: Nat
  for t: List<&2, Nat>
  for k: Nat
  for u: List<&2, Nat>
  {S.lex_le(h <> t, k <> u) == Bool.or(P.lt(h, k), Bool.and(P.eq(h, k), S.lex_le(t, u))) : Bool}

# LAW: a list is below or equal to itself. This is the law with content: at a
# variable list neither side reduces, and the step's answer is `True{}` only
# because each head is equal to itself and not below itself -- which is a fact
# about `P.eq` and `P.lt`, not an unfolding. A body that answered `False{}` on a
# tie, or that read a tie as a decision instead of falling through to the tails,
# leaves this law unconvertible.
law lex_le_self:
  for +xs: List<&2, Nat>
  {S.lex_le(xs, xs) == True{} : Bool}

# LAW: a list is below or equal to its own extension. This is the second law
# with content, and it is what says a shorter prefix is the smaller one: the
# left-hand side is a comparison of `xs` against `xs` followed by `ys`, at every
# `ys`, and the right-hand side is `True{}` -- so a body that answered `False{}`
# once the first list ran out is separated here, and so is one whose walk stops
# before the tails. `P.append` matches on its first argument, so with a variable
# `xs` neither side reduces: this one is an induction as well.
law lex_le_append:
  for +xs: List<&2, Nat>
  for ys: List<&2, Nat>
  {S.lex_le(xs, P.append(xs, ys)) == True{} : Bool}
