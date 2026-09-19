import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `swap_adjacent` steps on the list, so both sides reduce on `Nil{}`.
def L.swap_adjacent_nil():
  {==}

# A one-element list is a cons cell, so the body reduces through both matches
# and answers the element in front of the empty list.
def L.swap_adjacent_single(x):
  {==}

# Definitional: both sides reduce to the second element in front of the first,
# in front of the swaps of the rest.
def L.swap_adjacent_cons(x, y, t):
  {==}

# Inductive in the list: `len` matches on its first argument, so with a variable
# list the goal does not reduce on its own. The step case splits on the tail --
# a lone element contributes one to each side, and a pair contributes two --
# leaving the hypothesis at the tail from the third element on either way.
def L.swap_adjacent_len(xs):
  match xs:
    case Nil{}:
      {==}
    case x <> t:
      match t:
        case Nil{}:
          {==}
        case y <> t2:
          %L.swap_adjacent_len(t2) : {1n + (1n + P.len(S.swap_adjacent(t2))) == 1n + (1n + _) : Nat}
          {==}

# Inductive in the list, and the step case splits on the tail as the length law
# does. On a lone element the inner swap answers the element again; on a pair
# the outer swap rebuilds `x` in front of `y` in front of the swaps of the
# tail's tail, which is where the hypothesis applies.
def L.swap_adjacent_involutive(xs):
  match xs:
    case Nil{}:
      {==}
    case x <> t:
      match t:
        case Nil{}:
          {==}
        case y <> t2:
          %L.swap_adjacent_involutive(t2) : {x <> (y <> S.swap_adjacent(S.swap_adjacent(t2))) == x <> (y <> _) : List<Nat>}
          {==}
