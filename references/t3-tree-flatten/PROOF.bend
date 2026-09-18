import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The list lemmas. `flatten_leaves` needs the length of an `append`, and
# `flatten_mirror` needs the reversal of one; both are inductions on the list,
# independent of the tree the laws are about. Every list parameter is `+`
# because each of these steps uses its subject twice -- the recursive call and
# the goal that is left over -- and the second use is a Lone violation
# otherwise. Nothing here may cite a law.
def Policy.append_nil(+xs: List<&2, Nat>) -> {P.append(xs, Nil{}) == xs : List<&2, Nat>}:
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Policy.append_nil(t) : {h <> P.append(t, Nil{}) == h <> _ : List<&2, Nat>}
      {==}

def Policy.len_append(+xs: List<&2, Nat>, +ys: List<&2, Nat>) -> {P.len(P.append(xs, ys)) == P.len(xs) + P.len(ys) : Nat}:
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Equal.sym(Nat, P.len(P.append(t, ys)), P.len(t) + P.len(ys), Policy.len_append(t, ys)) : {1n + _ == (1n + P.len(t)) + P.len(ys) : Nat}
      {==}

def Policy.snoc_append(+xs: List<&2, Nat>, +ys: List<&2, Nat>, +y: Nat) -> {P.snoc(P.append(xs, ys), y) == P.append(xs, P.snoc(ys, y)) : List<&2, Nat>}:
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Policy.snoc_append(t, ys, y) : {h <> P.snoc(P.append(t, ys), y) == h <> _ : List<&2, Nat>}
      {==}

def Policy.rev_append(+xs: List<&2, Nat>, +ys: List<&2, Nat>) -> {P.rev(P.append(xs, ys)) == P.append(P.rev(ys), P.rev(xs)) : List<&2, Nat>}:
  match xs:
    case Nil{}:
      %Equal.sym(List<&2, Nat>, P.append(P.rev(ys), Nil{}), P.rev(ys), Policy.append_nil(P.rev(ys))) : {P.rev(ys) == _ : List<&2, Nat>}
      {==}
    case h <> t:
      %Equal.sym(List<&2, Nat>, P.rev(P.append(t, ys)), P.append(P.rev(ys), P.rev(t)), Policy.rev_append(t, ys)) : {P.snoc(_, h) == P.append(P.rev(ys), P.snoc(P.rev(t), h)) : List<&2, Nat>}
      %Equal.sym(List<&2, Nat>, P.snoc(P.append(P.rev(ys), P.rev(t)), h), P.append(P.rev(ys), P.snoc(P.rev(t), h)), Policy.snoc_append(P.rev(ys), P.rev(t), h)) : {_ == P.append(P.rev(ys), P.snoc(P.rev(t), h)) : List<&2, Nat>}
      {==}

# Both definitional laws are the unfolding of `flatten` at a constructor.
def L.flatten_leaf(v):
  {==}

def L.flatten_node(l, r):
  {==}

# The tree induction, with the length of an append as the list lemma it needs.
# Both subtrees are live twice in the step, which is the `+t` on the law.
def L.flatten_leaves(t):
  match t:
    case P.Leaf{v}:
      {==}
    case P.Node{l, r}:
      %Equal.sym(Nat, P.len(P.append(S.flatten(l), S.flatten(r))), P.len(S.flatten(l)) + P.len(S.flatten(r)), Policy.len_append(S.flatten(l), S.flatten(r))) : {_ == P.leaves(l) + P.leaves(r) : Nat}
      %Equal.sym(Nat, P.len(S.flatten(l)), P.leaves(l), L.flatten_leaves(l)) : {_ + P.len(S.flatten(r)) == P.leaves(l) + P.leaves(r) : Nat}
      %Equal.sym(Nat, P.len(S.flatten(r)), P.leaves(r), L.flatten_leaves(r)) : {P.leaves(l) + _ == P.leaves(l) + P.leaves(r) : Nat}
      {==}

# The same tree induction with the other list lemma: the two subtrees are
# flattened by the hypotheses, and the reversal of the append is what puts them
# back in the order the mirror puts them.
def L.flatten_mirror(t):
  match t:
    case P.Leaf{v}:
      {==}
    case P.Node{l, r}:
      %Equal.sym(List<&2, Nat>, S.flatten(P.mirror(r)), P.rev(S.flatten(r)), L.flatten_mirror(r)) : {P.append(_, S.flatten(P.mirror(l))) == P.rev(P.append(S.flatten(l), S.flatten(r))) : List<&2, Nat>}
      %Equal.sym(List<&2, Nat>, S.flatten(P.mirror(l)), P.rev(S.flatten(l)), L.flatten_mirror(l)) : {P.append(P.rev(S.flatten(r)), _) == P.rev(P.append(S.flatten(l), S.flatten(r))) : List<&2, Nat>}
      %Equal.sym(List<&2, Nat>, P.rev(P.append(S.flatten(l), S.flatten(r))), P.append(P.rev(S.flatten(r)), P.rev(S.flatten(l))), Policy.rev_append(S.flatten(l), S.flatten(r))) : {P.append(P.rev(S.flatten(r)), P.rev(S.flatten(l))) == _ : List<&2, Nat>}
      {==}
