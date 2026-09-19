import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `tree_leaf_count` steps on the constructor, so both of these are definitional:
# at a leaf both sides are `1n`, and at a node both sides are
# `S.tree_leaf_count(l) + S.tree_leaf_count(r)`.
def L.tree_leaf_count_leaf(v):
  {==}

def L.tree_leaf_count_node(l, r):
  {==}

# A list lemma, and the policy's to write: the length of an append is the sum
# of the lengths. The prelude does not have it, and without it the third law
# below stops one associativity short of an identity. It is stated `len ++ len`
# on the left so that the rewrite below replaces the appended form with the sum.
def Policy.len_append(xs: List<&2, Nat>, ys: List<&2, Nat>) -> {P.len(xs) + P.len(ys) == P.len(P.append(xs, ys)) : Nat}:
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Policy.len_append(t, ys) : {1n + P.len(t) + P.len(ys) == 1n + _ : Nat}
      {==}

# The induction is in the tree. The step reduces both sides to a sum of the two
# subtrees' readings and closes with `Policy.len_append` once and the two
# hypotheses, one per subtree.
def L.tree_leaf_count_flatten(t):
  match t:
    case P.Leaf{v}:
      {==}
    case P.Node{+l, +r}:
      %Policy.len_append(P.flatten(l), P.flatten(r)) : {S.tree_leaf_count(l) + S.tree_leaf_count(r) == _ : Nat}
      %L.tree_leaf_count_flatten(l) : {S.tree_leaf_count(l) + S.tree_leaf_count(r) == _ + P.len(P.flatten(r)) : Nat}
      %L.tree_leaf_count_flatten(r) : {S.tree_leaf_count(l) + S.tree_leaf_count(r) == S.tree_leaf_count(l) + _ : Nat}
      {==}
