import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `P.rightmost` and the recursion descend the same spine, so the goal after
# unfolding is the hypothesis at the right subtree itself.
def L.snoc_tree_rightmost(t, v):
  match t:
    case P.Leaf{x}:
      {==}
    case P.Node{l, r}:
      L.snoc_tree_rightmost(r, v)

# `P.leftmost` stops at the left subtree and the recursion never touches it, so
# both constructors are definitional; the right subtree the step rebuilds is
# not observed here at all.
def L.snoc_tree_leftmost(t, v):
  match t:
    case P.Leaf{x}:
      {==}
    case P.Node{l, r}:
      {==}

# The step replaces the right-subtree spine with its hypothesis. The rewrite
# needs `Equal.sym` because the hypothesis points the other way: it states
# `right_spine(snoc_tree(r, v)) == 1n + right_spine(r)`, and what has to come
# out of the goal is the `right_spine(snoc_tree(r, v))` occurrence. With the
# `1n` on the outside of the law, both sides are then the same term.
def L.snoc_tree_right_spine(t, v):
  match t:
    case P.Leaf{x}:
      {==}
    case P.Node{l, r}:
      %Equal.sym(Nat, P.right_spine(S.snoc_tree(r, v)), 1n + P.right_spine(r), L.snoc_tree_right_spine(r, v)) :
          {1n + _ == 1n + (1n + P.right_spine(r)) : Nat}
      {==}
