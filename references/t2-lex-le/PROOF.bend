import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The match steps on `Nil{}` and answers `True{}` without looking at `ys`.
def L.lex_le_nil_left(ys):
  {==}

# The match steps on the cons cell and then finds `Nil{}` where it wants a
# second element.
def L.lex_le_nil_right(h, t):
  {==}

# Both sides are the same `or` of the same two head comparisons and the same
# recursive call.
def L.lex_le_cons(h, t, k, u):
  {==}

# Helper lemmas. `Policy.` is the reserved namespace: the gate ignores it and the
# credit path does not count it, but none of them may cite a law.

# Two equal elements compare equal, so the prelude's equality test is `True{}` on
# a pair of the same value. The descent strips one successor from both sides at
# once, so the hypothesis is the same statement one step down, and the step
# rewrite is what carries it back up.
def Policy.eq_refl(a: Nat) -> {P.eq(a, a) == True{} : Bool}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Equal.sym(Bool, P.eq(p, p), True{}, Policy.eq_refl(p)) : {_ == True{} : Bool}
      {==}

# No number is strictly below itself, so the prelude's order test is `False{}` on
# a pair of the same value. Same descent, same shape.
def Policy.lt_irrefl(a: Nat) -> {P.lt(a, a) == False{} : Bool}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Equal.sym(Bool, P.lt(p, p), False{}, Policy.lt_irrefl(p)) : {_ == False{} : Bool}
      {==}

# The induction is in `xs`. The step reduces both sides to the `or` of the head's
# comparison with itself and the `and` of the head's equality with itself and the
# tail's own comparison; the hypothesis replaces the tail's comparison with
# `True{}`, the two helper lemmas replace the head's comparisons, and what is
# left absorbs into `True{}` because `or` of a `False{}` is its second argument
# and `and` of two `True{}`s is the second one. The head is read live twice --
# once per helper lemma -- so it is declared reusable, and the tail is read once
# by the hypothesis.
def L.lex_le_self(xs):
  match xs:
    case Nil{}:
      {==}
    case +h <> t:
      %Equal.sym(Bool, S.lex_le(t, t), True{}, L.lex_le_self(t)) : {Bool.or(P.lt(h, h), Bool.and(P.eq(h, h), _)) == True{} : Bool}
      %Equal.sym(Bool, P.eq(h, h), True{}, Policy.eq_refl(h)) : {Bool.or(P.lt(h, h), Bool.and(_, True{})) == True{} : Bool}
      %Equal.sym(Bool, P.lt(h, h), False{}, Policy.lt_irrefl(h)) : {Bool.or(_, True{}) == True{} : Bool}
      {==}

# The same induction, with the second list an extension of the first rather than
# the first itself. `append` puts the same head in front of the tail's own
# extension, so the step's two sides are the same comparison of the same head
# with itself, and the same three rewrites close it.
def L.lex_le_append(xs, ys):
  match xs:
    case Nil{}:
      {==}
    case +h <> t:
      %Equal.sym(Bool, S.lex_le(t, P.append(t, ys)), True{}, L.lex_le_append(t, ys)) : {Bool.or(P.lt(h, h), Bool.and(P.eq(h, h), _)) == True{} : Bool}
      %Equal.sym(Bool, P.eq(h, h), True{}, Policy.eq_refl(h)) : {Bool.or(P.lt(h, h), Bool.and(_, True{})) == True{} : Bool}
      %Equal.sym(Bool, P.lt(h, h), False{}, Policy.lt_irrefl(h)) : {Bool.or(_, True{}) == True{} : Bool}
      {==}
