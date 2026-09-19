import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `P.leftmost` descends the left spine and `tree_map` maps the leaf it arrives
# at, so the goal after unfolding is the hypothesis at the left subtree itself.
def L.tree_map_leftmost(t):
  match t:
    case P.Leaf{v}:
      {==}
    case P.Node{l, r}:
      L.tree_map_leftmost(l)

# The same on the right spine; only the right subtree is live.
def L.tree_map_rightmost(t):
  match t:
    case P.Leaf{v}:
      {==}
    case P.Node{l, r}:
      L.tree_map_rightmost(r)

# `P.leaves` is a sum of the two subtree counts, so the step replaces each
# subtree with its hypothesis and the two sides agree term for term. Each
# rewrite needs `Equal.sym` because the hypothesis points the other way: it
# states `leaves(map(l)) == leaves(l)`, and what has to come out of the goal is
# the `leaves(map(l))` occurrence.
def L.tree_map_leaves(t):
  match t:
    case P.Leaf{v}:
      {==}
    case P.Node{l, r}:
      %Equal.sym(Nat, P.leaves(S.tree_map(l)), P.leaves(l), L.tree_map_leaves(l)) :
          {_ + P.leaves(S.tree_map(r)) == P.leaves(l) + P.leaves(r) : Nat}
      %Equal.sym(Nat, P.leaves(S.tree_map(r)), P.leaves(r), L.tree_map_leaves(r)) :
          {P.leaves(l) + _ == P.leaves(l) + P.leaves(r) : Nat}
      {==}
