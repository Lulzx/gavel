import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `tree_size` steps on the constructor, so both of these are definitional: at a
# leaf both sides are `1n`, and at a node both sides are
# `1n + S.tree_size(l) + S.tree_size(r)`.
def L.tree_size_leaf(v):
  {==}

def L.tree_size_node(l, key, r):
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

# The induction is in the tree. The step reduces both sides to a cons in front
# of the two subtrees' readings and closes with `Policy.len_append` once and the
# two hypotheses, one per subtree.
def L.tree_size_nodes(t):
  match t:
    case P.Leaf{v}:
      {==}
    case P.Node{+l, key, +r}:
      %Policy.len_append(P.nodes(l), P.nodes(r)) : {S.tree_size(P.Node{l, key, r}) == 1n + _ : Nat}
      %L.tree_size_nodes(l) : {1n + S.tree_size(l) + S.tree_size(r) == 1n + (_ + P.len(P.nodes(r))) : Nat}
      %L.tree_size_nodes(r) : {1n + S.tree_size(l) + S.tree_size(r) == 1n + (S.tree_size(l) + _) : Nat}
      {==}
