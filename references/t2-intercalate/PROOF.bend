import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The collection is the literal `Nil{}`, which is the first case of the outer
# match, so both sides are the empty list.
def L.intercalate_nil(sep):
  {==}

# `xs <> Nil{}` is a cons cell whose tail is `Nil{}`, so the outer match takes
# the cons case and the inner match takes its empty case, where the answer is the
# head itself.
def L.intercalate_single(sep, xs):
  {==}

# The outer match takes the cons case and the inner match sees the cons tail, so
# both sides reduce to the first list, the separator and the recursive call.
def L.intercalate_cons(sep, a, b, t):
  {==}

# `P.append` is not a target, so its own two facts are proved here. This one is
# the identity that lets the last law relate the answer to the concatenation:
# appending nothing changes nothing. It is stated with the list on the left
# because that is the orientation the last law needs -- it replaces a `P.append`
# on the right-hand side of a goal.
def Policy.append_nil(xs: List<&2, Nat>) -> {xs == P.append(xs, Nil{}) : List<&2, Nat>}:
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Policy.append_nil(t) : {h <> t == h <> _ : List<&2, Nat>}
      {==}

# The one law that needs an induction. `xss` is a variable, so `intercalate` is
# stuck and `{==}` gets nowhere. The match is on `xss`, and inside the cons case
# a second match on the tail, because `intercalate`'s own answer has two cases
# there and `concat` is one step ahead of it.
#
#   `Nil{}`: both sides are the empty list.
#   `h <> Nil{}`: the inner match takes its empty case, so the left is `h` and
#     the right is `P.append(h, P.concat(Nil{}))`, which is `P.append(h, Nil{})`;
#     the identity proved above turns that back into `h`.
#   `h <> (h2 <> t2)`: the inner match takes the cons case. The left is
#     `P.append(h, P.append(Nil{}, ...))`, which is `P.append(h, ...)` because
#     appending an empty list to the front changes nothing, and the hypothesis --
#     whose subject is the smaller collection `h2 <> t2` -- turns the recursive
#     call inside it into `P.concat(h2 <> t2)`, which is the right side unfolded.
def L.intercalate_nil_sep(xss):
  match xss:
    case Nil{}:
      {==}
    case h <> t:
      match t:
        case Nil{}:
          %Policy.append_nil(h) : {h == _ : List<&2, Nat>}
          {==}
        case h2 <> t2:
          %Equal.sym(List<&2, Nat>, S.intercalate(Nil{}, h2 <> t2), P.concat(h2 <> t2), L.intercalate_nil_sep(h2 <> t2)) : {P.append(h, _) == P.append(h, P.concat(h2 <> t2)) : List<&2, Nat>}
          {==}
