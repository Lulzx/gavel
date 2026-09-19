import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: a leaf is not an interior node, so it contributes nothing, whatever value
# it carries. Both sides compute, so this is definitional, and it is the
# absolute anchor: the right-hand side is a literal and calls no target. The
# step law below is stated at `P.Node{l, key, r}`, so it never reaches a leaf,
# and a body whose leaf case answered `1n` -- or the value `v`, or anything but
# `0n` -- is caught only here.
law internal_count_leaf:
  for v: Nat
  {S.internal_count(P.Leaf{v}) == 0n : Nat}

# LAW: a node is one interior node of its own in addition to the interior nodes
# of its two subtrees. Both sides compute, so this is definitional too, and it
# is the law that says the answer is built from *both* subtrees and that a node
# is counted once: a body that descended one side only, or that added `2n` for
# the node, or that forgot the node's own contribution, leaves the two sides
# here unconvertible. The key is bound by the pattern and not read, which is
# what makes this a count of positions rather than of anything the nodes carry.
law internal_count_node:
  for l: P.Tree
  for key: Nat
  for r: P.Tree
  {S.internal_count(P.Node{l, key, r}) == 1n + S.internal_count(l) + S.internal_count(r) : Nat}

# LAW: the count is how many entries `P.inner` lists. This is the law with
# content, and the one that reads the tree rather than the recursion: `P.inner`
# lists one key per interior node and nothing for a leaf, so a body that counted
# the leaves -- or that counted every node -- is separated here even when it
# takes the recursion the two laws above describe. It is also the law whose
# right-hand side calls no target: the prelude does the observing. The tree is a
# variable, so `P.inner` does not reduce and neither does `P.len`, and this one
# is the induction rather than an unfolding.
law internal_count_inner:
  for t: P.Tree
  {S.internal_count(t) == P.len(P.inner(t)) : Nat}
