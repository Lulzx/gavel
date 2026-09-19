import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The input is the literal `Nil{}`, which is the first case of the match, so
# both sides reduce to `Nil{}` by unfolding alone.
def L.concat_map_nil():
  {==}

# `h <> t` is a cons cell, so the match takes the cons case and both sides
# reduce to `expand(h)` appended to the same call on `t`.
def L.concat_map_cons(h, t):
  {==}

# Inductive in `xs`. `append` steps on `expand(h)`, which is a concrete cons
# cell, so both sides of the step unfold the head down to `h` and its successor
# and the goal is `h <> (h + 1n) <> concat_map(t)` against the same prefix
# followed by `concat(map_expand(t))`. The hypothesis at the tail is the only
# mention of the tail that has to move, so it is the one rewrite the step
# needs: it is flipped, because the goal has the map-then-concat form on the
# right.
def L.concat_map_concat(xs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Equal.sym(List<&2, Nat>, S.concat_map(t), P.concat(P.map_expand(t)), L.concat_map_concat(t)) : {h <> (h + 1n) <> _ == h <> (h + 1n) <> P.concat(P.map_expand(t)) : List<&2, Nat>}
      {==}

# Inductive in `xs`. `expand`'s answer is a concrete cons cell, so the head of
# the step unfolds all the way through `append` and `len` and the goal is
# `1n + (1n + P.len(concat_map(t)))` against `1n + (1n + P.elen(t))`: one use of
# the hypothesis at the tail is the whole step. The `2n` that `P.elen` steps by
# is the two elements `P.expand` puts in, one per unfolding of `len`.
def L.concat_map_len(xs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %L.concat_map_len(t) : {1n + (1n + P.len(S.concat_map(t))) == 1n + (1n + _) : Nat}
      {==}
