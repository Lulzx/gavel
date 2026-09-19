import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `internal_count` steps on the constructor, so both of these are definitional:
# at a leaf both sides are `0n`, and at a node both sides are
# `1n + S.internal_count(l) + S.internal_count(r)`.
def L.internal_count_leaf(v):
  {==}

def L.internal_count_node(l, key, r):
  {==}

# A list lemma, and the policy's to write: the length of an append is the sum of
# the lengths. The prelude does not have it, and without it the third law below
# stops one associativity short of an identity. It is stated `len ++ len` on the
# left so that the rewrite below replaces the appended form with the sum.
def Policy.len_append(xs: List<&2, Nat>, ys: List<&2, Nat>) -> {P.len(xs) + P.len(ys) == P.len(P.append(xs, ys)) : Nat}:
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Policy.len_append(t, ys) : {1n + P.len(t) + P.len(ys) == 1n + _ : Nat}
      {==}

# The induction is in the tree. The step reduces both sides to a cons in front of
# the two subtrees' readings and closes with `Policy.len_append` once and the two
# hypotheses, one per subtree.
def L.internal_count_inner(t):
  match t:
    case P.Leaf{v}:
      {==}
    case P.Node{+l, key, +r}:
      %Policy.len_append(P.inner(l), P.inner(r)) : {S.internal_count(P.Node{l, key, r}) == 1n + _ : Nat}
      %L.internal_count_inner(l) : {1n + S.internal_count(l) + S.internal_count(r) == 1n + (_ + P.len(P.inner(r))) : Nat}
      %L.internal_count_inner(r) : {1n + S.internal_count(l) + S.internal_count(r) == 1n + (S.internal_count(l) + _) : Nat}
      {==}
