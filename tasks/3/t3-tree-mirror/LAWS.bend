import Base
import ./prelude.bend as P
import ./solution.bend as S

# The laws are stated over the prelude's own `Tree`, and every one of them binds
# its tree with `+`: the step of each law below uses both subtrees twice -- once
# as the recursive call and once in the goal that is left over -- and a variable
# is usable live once unless it is Many. `Tree is Data`, so the `+` is allowed
# on it; the same laws with a bare `for t: P.Tree` die on the second use of a
# subtree. Anything that is not the function the policy writes is `P.` -- the
# solution module re-exports nothing, so `S.size` is not a name.

# LAW: mirroring twice is the identity. This is the law that rules out the
# constant bodies: `mirror(t) = P.Leaf{0n}` makes the left side `P.Leaf{0n}` and
# the right side `t`, which is stuck on a variable, so `{==}` proves neither.
# The identity body passes it -- `t == t` -- which is the other body the laws
# have to rule out, and that is `mirror_leftmost`'s job.
law mirror_mirror:
  for +t: P.Tree
  {S.mirror(S.mirror(t)) == t : P.Tree}

# LAW: the leftmost leaf of a mirror is the rightmost leaf of the original. The
# step needs one hypothesis, at the left subtree only, and it is what the
# identity body cannot do: `P.rightmost(t) == P.leftmost(t)` is stuck on a
# variable, so `mirror(t) = t` proves nothing here. A body that swaps only the
# outer node (`P.Node{r, l}` without descending) or that mirrors only one side
# (`P.Node{mirror(r), l}`) leaves `P.rightmost(l) == P.leftmost(l)` or
# `P.rightmost(r) == P.leftmost(r)` behind, which is stuck as well.
law mirror_leftmost:
  for +t: P.Tree
  {P.rightmost(S.mirror(t)) == P.leftmost(t) : Nat}

# LAW: the other side of the same coin -- the rightmost leaf of a mirror is the
# leftmost leaf of the original. It is the dual of `mirror_leftmost` and it
# pins the same swap from the other end, so a body that gets the left spine
# right by accident of its unfolding does not get this one for free.
law mirror_rightmost:
  for +t: P.Tree
  {P.leftmost(S.mirror(t)) == P.rightmost(t) : Nat}

# LAW: mirroring does not change the size. The step has `P.size(mirror(r)) +
# P.size(mirror(l))` against `P.size(l) + P.size(r)`: the two hypotheses
# replace the subtrees, and what is left is `P.size(r) + P.size(l)` against
# `P.size(l) + P.size(r)`, which is an arithmetic fact about `Nat` rather than
# anything about trees. Both subtrees are live twice in this step, which is why
# the law binds `+t`; the arithmetic is a `Policy.` helper, and a helper may not
# cite a law.
law mirror_size:
  for +t: P.Tree
  {P.size(S.mirror(t)) == P.size(t) : Nat}
