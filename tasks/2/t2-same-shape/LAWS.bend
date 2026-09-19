import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: two leaves have the same shape, whatever they carry. Both sides compute,
# so this is definitional, and it is the absolute anchor: its right-hand side
# calls no target at all. It is the law that says a leaf is not a node, and it
# is one of the four that fix a pair of constructors -- the step law below only
# ever names two nodes, so a body whose leaf/leaf case answered `False{}` is
# caught only here.
law same_shape_leaf_leaf:
  for v: Nat
  for w: Nat
  {S.same_shape(P.Leaf{v}, P.Leaf{w}) == True{} : Bool}

# LAW: a leaf and a node do not have the same shape. Definitional, and the
# absolute anchor on the other side of the split. The step law, which names its
# two arguments as nodes, never reaches this pair, and the law below names the
# pair the other way round: a body that answered `True{}` for a leaf against a
# node is caught here and nowhere else.
law same_shape_leaf_node:
  for v: Nat
  for l: P.Tree
  for key: Nat
  for r: P.Tree
  {S.same_shape(P.Leaf{v}, P.Node{l, key, r}) == False{} : Bool}

# LAW: the same comparison the other way round. It is not the same law: the
# walk reads its first argument first, so a body that answered `False{}` for a
# leaf under a node and `True{}` for a node over a leaf satisfies the law above
# and is separated here.
law same_shape_node_leaf:
  for l: P.Tree
  for key: Nat
  for r: P.Tree
  for w: Nat
  {S.same_shape(P.Node{l, key, r}, P.Leaf{w}) == False{} : Bool}

# LAW: two nodes have the same shape exactly when both pairs of subtrees do.
# Both sides compute, so this is the definition written out, and it is the law
# that says the answer is built from *both* subtrees. It is also the law whose
# right-hand side reads no value: the keys `k1` and `k2` are bound by the
# patterns and never named, so a body that compared them is separated here.
law same_shape_node_node:
  for l1: P.Tree
  for k1: Nat
  for r1: P.Tree
  for l2: P.Tree
  for k2: Nat
  for r2: P.Tree
  {S.same_shape(P.Node{l1, k1, r1}, P.Node{l2, k2, r2}) == Bool.and(S.same_shape(l1, l2), S.same_shape(r1, r2)) : Bool}

# LAW: relabelling every value does not change the shape. This is the law with
# content, and it is the one that says "ignoring the values they carry" out
# loud: its right-hand side is `True{}` at every tree, so a body that compared
# the values -- a leaf's `value`, or an interior `key` -- leaves the two sides
# apart even though the four laws above are satisfied by the recursion it would
# take. `P.relabel` matches on its argument, so with a variable `t` neither side
# reduces and this one is inductive rather than definitional.
law same_shape_relabel:
  for +t: P.Tree
  {S.same_shape(t, P.relabel(t)) == True{} : Bool}

# LAW: a tree has the same shape as itself. The law above fixes the values by
# moving them; this one fixes that the walk is reflexive whichever tree it is
# handed, including the ones no relabelling builds. It is inductive in `t` for
# the same reason.
law same_shape_self:
  for +t: P.Tree
  {S.same_shape(t, t) == True{} : Bool}
