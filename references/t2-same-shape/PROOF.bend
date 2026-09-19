import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# Both arguments are leaves, so the match takes its first leaf case and both
# sides are `True{}`.
def L.same_shape_leaf_leaf(v, w):
  {==}

# The first argument is a leaf and the second a node, so the match takes its
# second case and both sides are `False{}`.
def L.same_shape_leaf_node(v, l, key, r):
  {==}

# The first argument is a node and the second a leaf, so the match takes its
# third case and both sides are `False{}`.
def L.same_shape_node_leaf(l, key, r, w):
  {==}

# Two nodes, so the match takes its fourth case and both sides are the same
# `Bool.and` of the same two recursive calls.
def L.same_shape_node_node(l1, k1, r1, l2, k2, r2):
  {==}

# The induction is in the tree. The step reduces both sides to the `and` of the
# two subtrees' own relabelling comparisons; the two hypotheses replace those
# with `True{}` one at a time, and `and` finds its answer in the first argument,
# so what is left is `True{}` against itself. The subtrees are read twice -- once
# by each hypothesis -- and a tree pattern binder carries its own mark, so both
# are marked `+`.
def L.same_shape_relabel(t):
  match t:
    case P.Leaf{v}:
      {==}
    case P.Node{+l, key, +r}:
      %Equal.sym(Bool, S.same_shape(l, P.relabel(l)), True{}, L.same_shape_relabel(l)) : {Bool.and(_, S.same_shape(r, P.relabel(r))) == True{} : Bool}
      %Equal.sym(Bool, S.same_shape(r, P.relabel(r)), True{}, L.same_shape_relabel(r)) : {Bool.and(True{}, _) == True{} : Bool}
      {==}

# The same induction, with the second argument the first one rather than a
# relabelling of it. The step still reduces to the `and` of the two subtree
# comparisons and the two hypotheses still replace them with `True{}`.
def L.same_shape_self(t):
  match t:
    case P.Leaf{v}:
      {==}
    case P.Node{+l, key, +r}:
      %Equal.sym(Bool, S.same_shape(l, l), True{}, L.same_shape_self(l)) : {Bool.and(_, S.same_shape(r, r)) == True{} : Bool}
      %Equal.sym(Bool, S.same_shape(r, r), True{}, L.same_shape_self(r)) : {Bool.and(True{}, _) == True{} : Bool}
      {==}
