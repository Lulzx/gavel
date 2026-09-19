import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The input is the literal `Nil{}`, which is the first case of the match, so both
# sides reduce to the empty list by unfolding alone.
def L.zip_with_const_nil(k):
  {==}

# `h <> t` is a cons cell, so the match takes the cons case and both sides reduce
# to the same pair in front of the same recursive answer.
def L.zip_with_const_step(h, k, t):
  {==}

# Inductive in `xs`. `P.fsts` matches on the answer, and the answer starts with a
# cons cell as soon as the input does, so the step reduces both sides to the
# element in front of the tail's first components: the hypothesis at the tail is
# exactly the term sitting behind the cons. `%e` replaces the hole with `e`'s
# left-hand side and the law is stated answer-first, so the hypothesis is flipped
# with `Equal.sym` -- after the flip its left side is the tail's element, which is
# what the hole has to become.
def L.zip_with_const_fsts(xs, k):
  match xs:
    case Nil{}:
      {==}
    case +h <> t:
      %Equal.sym(List<Nat>, P.fsts(S.zip_with_const(t, k)), t, L.zip_with_const_fsts(t, k)) : {h <> _ == h <> t : List<Nat>}
      {==}

# The other component, the same induction. The step leaves the constant in front
# of the tail's second components against `P.repeat` at one more than the tail's
# length, which unfolds to the constant in front of `P.repeat` at the tail's
# length: the hypothesis is the whole of what is left.
def L.zip_with_const_snds(xs, k):
  match xs:
    case Nil{}:
      {==}
    case +h <> t:
      %Equal.sym(List<Nat>, P.snds(S.zip_with_const(t, k)), P.repeat(P.len(t), k), L.zip_with_const_snds(t, k)) : {k <> _ == k <> P.repeat(P.len(t), k) : List<Nat>}
      {==}
