import Base
import ./prelude.bend as P
import ./solution.bend as S

# The laws are stated over the prelude's own `Tree`, and the two whose statement
# uses the tree twice bind it with `+`: the step of each is a case on the two
# constructors, and the tree is then live twice -- once as the recursive call
# the hypothesis replaces and once in what is left of the goal -- which a Lone
# variable cannot do. `Tree is Data`, so the `+` is allowed on it. Anything that
# is not the function the policy writes is `P.` -- the solution module
# re-exports nothing, so `S.flatten` is not a name.

# LAW: a leaf puts its own value in front of the accumulator. Both sides
# compute, so this is definitional. It is the law that fixes what a leaf is
# worth: a body that put the accumulator in front of the value, or dropped one
# of the two, leaves the two sides unconvertible.
law tree_fold_leaf:
  for v: Nat
  for acc: List<&2, Nat>
  {S.tree_fold(P.Leaf{v}, acc) == v <> acc : List<&2, Nat>}

# LAW: a node folds its right subtree first and then folds its left subtree onto
# the result. Both sides compute, so this is definitional too, and it is the law
# that fixes the *order*: a body that folded the left subtree first and handed
# the result to the right one is not equal to this at a node whose two subtrees
# differ, and neither is a body that folded one of them twice.
law tree_fold_node:
  for l: P.Tree
  for r: P.Tree
  for acc: List<&2, Nat>
  {S.tree_fold(P.Node{l, r}, acc) == S.tree_fold(l, S.tree_fold(r, acc)) : List<&2, Nat>}

# LAW: the accumulator comes out the far end, with the tree's leaves in front of
# it. The two definitional laws above already determine the fold, and this is
# the statement that gives the fold its meaning: the leaves come out in the
# order `P.flatten` puts them in, left to right, and the accumulator is a
# suffix rather than something the fold consumes or reorders. It is an
# induction in the tree and it does not close definitionally -- after the two
# hypotheses land, one side has the two flattened lists nested and the other has
# them side by side, and the reassociation of `P.append` is a list lemma the
# prelude does not have.
law tree_fold_flatten:
  for +t: P.Tree
  for +acc: List<&2, Nat>
  {S.tree_fold(t, acc) == P.append(P.flatten(t), acc) : List<&2, Nat>}
