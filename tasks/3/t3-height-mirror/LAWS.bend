import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: a leaf has no height. Both sides compute, so this is definitional, and it
# is the weak half: it fixes the bottom of the recursion, and a body that
# ignored the tree entirely would still satisfy it.
law height_leaf:
  {S.height(P.Leaf{}) == 0n : Nat}

# LAW: the step of the height. Both sides compute, so this is definitional too,
# and it is the law that says the answer is built from *both* subtrees: a body
# that descended one side only -- `1n + S.height(l)` -- agrees with the law
# below on any tree that leans that way and leaves the two sides here
# unconvertible.
law height_node:
  for l: P.Tree
  for r: P.Tree
  {S.height(P.Node{l, r}) == 1n + P.max(S.height(l), S.height(r)) : Nat}

# LAW: mirroring does not change the height. The two subtrees are live twice in
# the step -- once as the recursive call the hypothesis replaces and once in the
# goal that is left over -- which is why the law binds `+t`. After the two
# hypotheses land, what is left is `P.max(h, k)` against `P.max(k, h)`, which is
# an arithmetic fact about `Nat`: `P.max` steps on its first argument, so on
# variables the two are not convertible, and the helper that proves they are is
# the policy's.
law height_mirror:
  for +t: P.Tree
  {S.height(P.mirror(t)) == S.height(t) : Nat}
