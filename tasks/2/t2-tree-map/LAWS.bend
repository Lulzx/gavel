import Base
import ./prelude.bend as P
import ./solution.bend as S

# The laws are stated over the prelude's own `Tree`, and each binds its tree
# with `+`: the step of each is a case on the two constructors, and the tree is
# then live twice -- once as the recursive call the hypothesis replaces and
# once in what is left of the goal -- which a Lone variable cannot do. `Tree is
# Data`, so the `+` is allowed on it; the same laws with a bare `for t: P.Tree`
# die on the second use. Anything that is not the function the policy writes is
# `P.` -- the solution module re-exports nothing, so `S.leaves` is not a name.

# LAW: the leftmost leaf of a mapped tree is `P.inc` of the leftmost leaf of the
# original. `P.leftmost` descends the left spine, so the step is the hypothesis
# at the left subtree and nothing else. This is the law that rules out the
# identity body (`P.leftmost(t) == P.inc(P.leftmost(t))` is stuck on a
# variable) and the constant ones, which map nothing at all.
law tree_map_leftmost:
  for +t: P.Tree
  {P.leftmost(S.tree_map(t)) == P.inc(P.leftmost(t)) : Nat}

# LAW: the dual, descending the right spine. It is not redundant with the one
# above: a body that maps only the left subtree of each node satisfies
# `tree_map_leftmost` and fails this one, and a body that maps only the right
# subtree does the opposite.
law tree_map_rightmost:
  for +t: P.Tree
  {P.rightmost(S.tree_map(t)) == P.inc(P.rightmost(t)) : Nat}

# LAW: mapping does not change how many leaves there are. The step is the two
# hypotheses side by side -- `leaves` is a sum, so nothing else is needed -- and
# it is what a body that drops a subtree, or that maps one subtree twice,
# cannot do while the two laws above still hold.
law tree_map_leaves:
  for +t: P.Tree
  {P.leaves(S.tree_map(t)) == P.leaves(t) : Nat}
