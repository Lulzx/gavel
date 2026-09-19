import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: a tip holds no node at any depth. Both sides compute -- the outer match
# takes the tip case and answers `0n` whatever the depth is -- so this is
# definitional, and it is one of the laws whose right-hand side does not call the
# target: the absolute anchor. It is the only law that reaches a tip below depth
# zero, and it is read at a variable depth, so a body that counted a tip as a
# node is separated here and nowhere else.
law count_at_depth_tip:
  for d: Nat
  {S.count_at_depth(P.Tip{}, d) == 0n : Nat}

# LAW: the depth-zero count is `1n` at a bin and `0n` at a tip, whatever the tree
# is. This is the law with content, and the one that observes the tree rather
# than the recursion: `P.is_tip` reads whether the tree is empty at its own root,
# so a body that answered a subtree's count at depth zero, or that counted the
# empty tree as a node, is separated here even though every law above is
# satisfied by the recursion it would take. The tree is a variable, so nothing
# reduces and this one needs the case split rather than a computation -- it is
# also the only law a proof that claims every law is true by definition cannot
# close. It is the second law whose right-hand side does not call the target.
law count_at_depth_zero:
  for t: P.Tree
  {S.count_at_depth(t, 0n) == P.at_if(P.is_tip(t), 0n, 1n) : Nat}

# LAW: below a bin, depth `1n + d` is depth `d` of the two subtrees, added. Both
# sides compute, so this is definitional, and it is the law that says the answer
# is built from *both* subtrees and that descending costs exactly one level: a
# body that descended one side only leaves the two sides unconvertible on any
# tree whose subtrees differ, and a body that carried the same depth into the
# subtrees -- `1n + d` rather than `d` -- is separated here too. Nothing in it
# reads the key, because nothing in a count does.
law count_at_depth_step:
  for l: P.Tree
  for key: Nat
  for r: P.Tree
  for d: Nat
  {S.count_at_depth(P.Bin{l, key, r}, 1n + d) == S.count_at_depth(l, d) + S.count_at_depth(r, d) : Nat}

# LAW: one closed tree, read at a depth below its root. The root is a bin and so
# are its two children, so at depth `1n` the answer is one for the child on the
# left and one for the child on the right, which is `2n`. Both sides are closed,
# so every match reduces. A body that counted a tip as a node, or that answered
# `1n` at every non-zero depth, satisfies several of the laws above and is
# separated here.
law count_at_depth_three:
  {S.count_at_depth(P.Bin{P.Bin{P.Tip{}, 1n, P.Tip{}}, 2n, P.Bin{P.Tip{}, 3n, P.Tip{}}}, 1n) == 2n : Nat}
