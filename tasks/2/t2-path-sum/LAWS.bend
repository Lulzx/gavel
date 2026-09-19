import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the path down to a leaf is the leaf's own value, so a bare leaf answers
# `v`. Both sides compute, so this is definitional, and it is the absolute
# anchor: the right-hand side is a binder and calls no target. It is also the
# law that separates this function from a count of leaves -- a body that
# answered `1n` here satisfies no other law's left-hand side, but this one is
# where a leaf's value enters the answer at all.
law path_sum_leaf:
  for v: Nat
  {S.path_sum(P.Leaf{v}) == v : Nat}

# LAW: a node's key lies on the path of every leaf beneath it, so it is counted
# once per leaf: the answer is both subtrees' own answers plus the key times the
# node's leaf count. Both sides compute, so this is definitional, and it is the
# law with the step: a body that counted the key once for the node -- the
# whole-tree sum's shape -- or that forgot to multiply by the leaf count, is
# separated by the two sides. The two leaf counts are `P.leaves` of the
# subtrees, which is the prelude's definition of what a count is.
law path_sum_node:
  for l: P.Tree
  for key: Nat
  for r: P.Tree
  {S.path_sum(P.Node{l, key, r}) == Nat.add(Nat.add(S.path_sum(l), S.path_sum(r)), Nat.mul(key, Nat.add(P.leaves(l), P.leaves(r)))) : Nat}

# LAW: one closed tree, read at the root. The two laws above fix the walk at
# every shape of argument; this one fixes, on a tree whose subtrees are leaves,
# what the numbers come to: the two leaves answer `1n` and `3n`, and the key
# `2n` lies on two paths, so the sum is `4n + 2n + 2n = 8n`. A body that counted
# the key once answers `6n` here -- and every other law in this file is
# satisfied by that body except the deeper tree below.
law path_sum_three:
  {S.path_sum(P.Node{P.Leaf{1n}, 2n, P.Leaf{3n}}) == 8n : Nat}

# LAW: the same reading one level down. The inner node answers `8n`, the third
# leaf `4n`, and the root's key `5n` lies on all three paths, so the sum is
# `12n + 15n = 27n`. This is the law that separates a body which multiplies by
# the leaf count from one which multiplies by the wrong count -- the two agree
# on a tree with exactly two leaves.
law path_sum_deep:
  {S.path_sum(P.Node{P.Node{P.Leaf{1n}, 2n, P.Leaf{3n}}, 5n, P.Leaf{4n}}) == 27n : Nat}

# LAW: a tree with every value dropped to zero answers `0n`. This is the law
# with content: at a variable tree neither side reduces, and the answer is `0n`
# only because the key of every node is zero and so its contribution vanishes --
# which is a fact about `P.zeroed` and `Nat.mul`, not an unfolding. A body that
# answered a constant per leaf, or that added anything of its own at an interior
# node, leaves this law unconvertible.
law path_sum_zeroed:
  for +t: P.Tree
  {S.path_sum(P.zeroed(t)) == 0n : Nat}
