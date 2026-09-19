import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The count is `0n` and the list is a cons cell, so `delete_at` steps twice and
# answers the tail.
def L.delete_at_zero(h, t):
  {==}

# An induction in `n`, though both cases turn out to be answers rather than
# steps: once `n` is a literal shape the match inside `delete_at` has stepped on
# the `Nil{}` list behind it and reaches `Nil{}` at either count.
def L.delete_at_nil(n):
  match n:
    case 0n:
      {==}
    case 1n+p:
      {==}

# Both sides are `delete_at`'s own unfolding: the count steps off the front and
# the head goes out in front of the recursive call.
def L.delete_at_succ(n, h, t):
  {==}

# An induction in `n`, with a split on `xs` in both cases. At `0n` the right-hand
# side reduces to `drop(1n, xs)`, which is the tail of a cons cell and `Nil{}` of
# the empty list -- the same two answers the left-hand side reaches. At `1n + p`
# the head of `xs` survives on both sides and what is left is the hypothesis at
# the tail, whose right-hand side carries `drop(1n, drop(p, t))` exactly as the
# goal does.
def L.delete_at_take_drop(n, xs):
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
          %Equal.sym(List<Nat>, S.delete_at(p, t), P.append(P.take(p, t), P.drop(1n, P.drop(p, t))), L.delete_at_take_drop(p, t)) : {h <> _ == h <> P.append(P.take(p, t), P.drop(1n, P.drop(p, t))) : List<Nat>}
          {==}
