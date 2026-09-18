import Base
import ./prelude.bend as P
import ./solution.bend as S

# Three laws, and they do different jobs. `inorder_node` pins the traversal: one
# element per node and the left traversal before the key. `inorder_size` is the
# measure, and it is what pins the empty tree, which `inorder_node` cannot reach.
# `inorder_transport` relates the two structures: a fold over the tree and a fold
# over the list the traversal produces.
#
# The order has to be stated by the step and nowhere else. The transport is a
# conjunction over a fold that is blind to permutations -- a body that emitted
# the right subtree first would still satisfy it -- and the measure counts
# without looking at where anything sits. A law about where the traversal
# *starts* is not enough either: it constrains a node whose left subtree
# traverses to the empty list, which is the node whose left subtree is empty,
# and a preorder-shaped body (key, then left, then right) agrees with an inorder
# one there and on the count while disagreeing in between.

# LAW: the step, and the reference's own unfolding. Definitional for the
# reference -- both sides are the same `append` -- and what it does is pin the
# order: it is the only law that says where the key sits relative to the two
# subtrees. It is not the whole law set's shape: the transport and the measure
# are inductions, which is why this one is allowed to be definitional, the same
# way `flatten_node` is in `t3-tree-flatten`.
law inorder_node:
  for l: P.Tree
  for key: Nat
  for r: P.Tree
  {S.inorder(P.Bin{l, key, r}) == P.append(S.inorder(l), key <> S.inorder(r)) : List<&2, Nat>}

# LAW: boundedness transports along the traversal. If every key of `t` is at
# most `b`, then every element of the list `t` flattens to is at most `b` -- the
# same predicate, stated twice, over the two structures, and the law that says
# they describe the same set of trees.
#
# The premise is the invariant and it is *used*: the step rewrites the goal with
# it and then transports through the fold equation. It is not decoration, and
# the law is not vacuous at `Tip{}` -- there the hypothesis reduces to
# `{True{} == True{}}` and the conclusion follows from the fold's own base case.
law inorder_transport:
  for +t: P.Tree
  for b: Nat
  for e: {P.bounded(t, b, True{}) == True{} : Bool}
  {P.bounded_list(S.inorder(t), b, True{}) == True{} : Bool}

# LAW: the traversal has one element per node. The measure is blind to order and
# it is what reaches `Tip{}`, where `inorder_node` says nothing: the traversal of
# the empty tree is the empty list, and a body that answered something else there
# satisfies every other law.
law inorder_size:
  for +t: P.Tree
  {P.len(S.inorder(t)) == P.size(t) : Nat}
