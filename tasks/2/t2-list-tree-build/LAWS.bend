import Base
import ./prelude.bend as P
import ./solution.bend as S

# The three measure laws bind the list `+`: each names it twice, once as the
# argument of the recursive call the law quantifies and once in the goal that
# is left, and a list that is live twice is not Lone. `build_cons` names its
# head and its tail once each and is written plain, and `build_nil` has no
# binders at all. Anything that is not the function the policy writes is `P.`
# -- the solution module re-exports nothing, so `S.leaves` is not a name.

# LAW: the shortest list builds the sentinel leaf. The left-hand side is a
# ground term and both sides compute, so this is definitional: it fixes the
# answer the recursion reaches when there is nothing left to build, and a
# sentinel leaf is what makes the node case total. It is the law the base-case
# rule is about -- an empty case is an answer a stopped match gives, not a step,
# so nothing else in this file looks at it.
law build_nil:
  {S.build(Nil{}) == P.Leaf{0n} : P.Tree}

# LAW: the shape of the answer at a cons, and where the head goes. Both sides
# compute, so this is definitional, and it is the law that pins the *leaning*:
# the head's leaf is the left child and the rest of the list is built into the
# right child, so the answer is a comb down the right. A body that put the head
# on the top of the right spine as a bare value, or that leaned the other way,
# leaves the two sides of this unconvertible.
law build_cons:
  for h: Nat
  for t: List<&2, Nat>
  {S.build(h <> t) == P.Node{P.Leaf{h}, S.build(t)} : P.Tree}

# LAW: one leaf per element, plus the sentinel. This is the induction: the
# successor case unfolds the answer into a node, `P.leaves` of a node is the sum
# of its halves, and the hypothesis at the tail is what rewrites the right half.
# The `1n` is on the outside for the reason `snoc_tree` puts it there -- the
# goal after that rewrite is `1n + P.leaves(...)` against `1n + (1n + P.len(t))`,
# and that is the form in which the two sides are the same term.
law build_leaves:
  for +bs: List<&2, Nat>
  {P.leaves(S.build(bs)) == 1n + P.len(bs) : Nat}

# LAW: every leaf of the answer is on its right spine. Two measures of the same
# tree, and together they say something neither says alone: `build_leaves` is
# satisfied by a right-leaning comb as well, and this is the law that rejects
# it. A tree whose leaves are all on its right spine has as many spine nodes as
# leaves, so the two laws share a right-hand side honestly -- what differs is
# the left.
law build_right_spine:
  for +bs: List<&2, Nat>
  {P.right_spine(S.build(bs)) == 1n + P.len(bs) : Nat}

# LAW: the bottom of the spine carries the last element of the list. The step is
# the hypothesis at the tail and nothing else, because `P.rightmost` descends
# the right spine and the `P.last_or_zero` fold walks to the end of the list,
# and both of them ignore the head. It is what a body that kept the shape and
# the count while losing the elements beyond the first cannot do.
law build_last:
  for +bs: List<&2, Nat>
  {P.rightmost(S.build(bs)) == P.last_or_zero(bs) : Nat}
