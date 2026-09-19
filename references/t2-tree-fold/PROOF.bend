import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The list lemma the content law needs: `append` is associative. It is an
# induction on the list, independent of the tree the law is about. Every list
# parameter is `+` because each step uses its subject twice -- the recursive
# call and the goal that is left over -- and the second use is a Lone violation
# otherwise. Nothing here may cite a law.
def Policy.append_assoc(+xs: List<&2, Nat>, +ys: List<&2, Nat>, +zs: List<&2, Nat>) -> {P.append(P.append(xs, ys), zs) == P.append(xs, P.append(ys, zs)) : List<&2, Nat>}:
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Equal.sym(List<&2, Nat>, P.append(P.append(t, ys), zs), P.append(t, P.append(ys, zs)), Policy.append_assoc(t, ys, zs)) : {h <> _ == h <> P.append(t, P.append(ys, zs)) : List<&2, Nat>}
      {==}

# The leaf case is the unfolding of `tree_fold` at a leaf, with `flatten` at a
# leaf on the other side: `append(v <> Nil{}, acc)` steps to `v <> acc`, which
# is the reader's own answer.
def L.tree_fold_leaf(v, acc):
  {==}

# The node case is the unfolding at a node on both sides, and the two sides are
# the same term.
def L.tree_fold_node(l, r, acc):
  {==}

# The tree induction. Its leaf case is the leaf law. Its node case unfolds both
# sides: the fold becomes `tree_fold(l, tree_fold(r, acc))` and `flatten`
# becomes `append(flatten(l), flatten(r))`. The first rewrite is the hypothesis
# at the right subtree, on the accumulator unchanged. The second is the
# hypothesis at the left subtree, on the accumulator the first rewrite built --
# which is why the hypothesis has to be cited at a term the match never named.
# What is left is `append(append(flatten(l), flatten(r)), acc)` against
# `append(flatten(l), append(flatten(r), acc))`, which is the list lemma. The
# first two rewrites need `Equal.sym` because each hypothesis points the other
# way: what has to come out of the goal is the `tree_fold` occurrence.
def L.tree_fold_flatten(t, acc):
  match t:
    case P.Leaf{v}:
      {==}
    case P.Node{l, r}:
      %Equal.sym(List<&2, Nat>, S.tree_fold(r, acc), P.append(P.flatten(r), acc), L.tree_fold_flatten(r, acc)) : {S.tree_fold(l, _) == P.append(P.append(P.flatten(l), P.flatten(r)), acc) : List<&2, Nat>}
      %Equal.sym(List<&2, Nat>, S.tree_fold(l, P.append(P.flatten(r), acc)), P.append(P.flatten(l), P.append(P.flatten(r), acc)), L.tree_fold_flatten(l, P.append(P.flatten(r), acc))) : {_ == P.append(P.append(P.flatten(l), P.flatten(r)), acc) : List<&2, Nat>}
      %Policy.append_assoc(P.flatten(l), P.flatten(r), acc) : {_ == P.append(P.append(P.flatten(l), P.flatten(r)), acc) : List<&2, Nat>}
      {==}
