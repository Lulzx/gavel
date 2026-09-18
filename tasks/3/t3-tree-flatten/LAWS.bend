import Base
import ./prelude.bend as P
import ./solution.bend as S

# The two measure laws bind their tree with `+`: a tree induction has two
# hypotheses, and each subtree is then live twice -- once as the recursive call
# and once in what is left of the goal -- which a Lone variable cannot do.
# `flatten_leaves` needs it again for the list helpers, whose own parameters are
# `+` in their signatures for the same reason. Anything that is not the
# function the policy writes is `P.` -- the solution module re-exports nothing.

# LAW: the leaves, left to right. The two definitional laws below fix the shape
# of the answer at each constructor and are what the measures cannot see: a body
# that drops a subtree still type-checks, and `flatten_len` alone would not
# notice it if the dropped leaves were balanced by something else.
law flatten_leaf:
  for v: Nat
  {S.flatten(P.Leaf{v}) == v <> Nil{} : List<&2, Nat>}

law flatten_node:
  for l: P.Tree
  for r: P.Tree
  {S.flatten(P.Node{l, r}) == P.append(S.flatten(l), S.flatten(r)) : List<&2, Nat>}

# LAW: the flattened list has one element per leaf. It is where the tree
# induction meets the list lemmas: the step unfolds `flatten` into an `append`,
# and `P.len` cannot step past it because `append` matches on its first
# argument, so the length of an append has to be a lemma of its own -- an
# induction on the list, not on the tree. The constant body `Nil{}` fails here
# (`0n == P.leaves(t)` is stuck), and so does a body that flattens one subtree
# twice, which is what makes this law and `flatten_node` non-redundant.
law flatten_leaves:
  for +t: P.Tree
  {P.len(S.flatten(t)) == P.leaves(t) : Nat}

# LAW: flattening a mirror is reversing a flattening. This is the law that pins
# the *order*: `flatten_leaves` accepts any body that produces the right
# multiset, including one that appends the two subtrees the wrong way round,
# and this is the one that rejects it. Its step needs the reassociation of
# `snoc` and `append` and the reversal of an `append` -- again list lemmas
# inside a tree induction, and again unable to be definitional, because `rev`
# matches on a list whose tail is the opaque `flatten(l)`.
law flatten_mirror:
  for +t: P.Tree
  {S.flatten(P.mirror(t)) == P.rev(S.flatten(t)) : List<&2, Nat>}
