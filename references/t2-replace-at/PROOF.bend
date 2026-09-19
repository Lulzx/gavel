import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# An induction in `n`, though both cases turn out to be answers rather than
# steps: once the count is a literal shape the outer match inside `replace_at`
# has stepped, and the inner match on the literal `Nil{}` answers `Nil{}` at
# either count.
def L.replace_at_nil(n, y):
  match n:
    case 0n:
      {==}
    case 1n+p:
      {==}

# The count is `0n` and the list is a cons cell, so the outer match steps and
# the inner one answers `y <> t` without looking behind it.
def L.replace_at_zero(h, t, y):
  {==}

# Both sides are `replace_at`'s own unfolding: the count steps off the front and
# the head goes out in front of the recursive call.
def L.replace_at_succ(n, h, t, y):
  {==}

# An induction in the count, with a split on the list in both cases. At `0n` the
# inner application has already answered, so the outer one replaces the element
# it stands in front of and both sides are `z <> t`. At `1n + p` the head
# survives the outer application, what comes back is the inner application's
# own step, and what is left is the hypothesis at the predecessor and the tail.
# `Equal.sym` is there because the goal has the twice-replaced list on the left
# and a rewrite step replaces the occurrence with the left-hand side of its
# equation: the hypothesis, flipped, has the once-replaced list there.
def L.replace_at_idem(n, xs, y, z):
  match n:
    case 0n:
      match xs:
        case Nil{}:
          {==}
        case h <> t:
          {==}
    case 1n+p:
      match xs:
        case Nil{}:
          {==}
        case h <> t:
          %Equal.sym(List<Nat>, S.replace_at(p, S.replace_at(p, t, y), z), S.replace_at(p, t, z), L.replace_at_idem(p, t, y, z)) : {h <> _ == h <> S.replace_at(p, t, z) : List<Nat>}
          {==}
