import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `Bool.or` matches on its first argument, so with a variable on the left the
# goal is stuck and this is a case analysis on both values rather than an
# unfolding. Both cases compute: `False{}` leaves the second argument on both
# sides, and `True{}` answers `True{}` on both sides.
def Policy.or_assoc(a: Bool, -b: Bool, -c: Bool)
    -> {Bool.or(a, Bool.or(b, c)) == Bool.or(Bool.or(a, b), c) : Bool}:
  match a:
    case False{}:
      {==}
    case True{}:
      {==}

def L.any_nil():
  {==}

def L.any_cons(h, t):
  {==}

def L.any_append(xs, ys):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      +ys = ys
      %Equal.sym(Bool, S.any(P.append(t, ys)), Bool.or(S.any(t), S.any(ys)),
                 L.any_append(t, ys)) :
          {Bool.or(h, _) == Bool.or(Bool.or(h, S.any(t)), S.any(ys)) : Bool}
      %Policy.or_assoc(h, S.any(t), S.any(ys)) :
          {Bool.or(h, Bool.or(S.any(t), S.any(ys))) == _ : Bool}
      {==}
