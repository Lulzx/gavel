import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `indexed` is asked for the helper applied to `0n`, so the two sides are the
# same term.
def L.indexed_zero(xs):
  {==}

# The list is a cons cell, so the head is paired with the position and the tail
# is numbered from the next one on both sides of `{==}`.
def L.indexed_cons(x, t, i):
  {==}

# One of the two laws that need the induction. The list is a variable, so the
# helper is stuck and `{==}` gets nowhere; the match is on the list, and the
# cons case is one use of the hypothesis at the tail, whose position has moved
# on by one.
#
#   `Nil{}`: both sides are `0n`.
#   `h <> t`: `plen` steps the pair off the front, leaving one plus the length
#     of the recursive call, and the hypothesis -- whose subject is the smaller
#     list `t` -- turns that into one plus the length of `t`, which is what the
#     right side unfolds to.
def L.indexed_len(xs, i):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %L.indexed_len(t, i + 1n) : {1n + P.plen(S.indexed_go(t, i + 1n)) == 1n + _ : Nat}
      {==}

# The same induction again, with the projection in place of the length.
#
#   `Nil{}`: both sides are `Nil{}`.
#   `h <> t`: `elems` steps the pair off the front and answers its second
#     component in front of the projection of the recursive call, and the
#     hypothesis at `t` turns that tail into `t` itself.
def L.indexed_elems(xs, i):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %L.indexed_elems(t, i + 1n) : {h <> P.elems(S.indexed_go(t, i + 1n)) == h <> _ : List<&2, Nat>}
      {==}
