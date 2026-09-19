import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# Two folds, one transport. The list lemma is an induction on the list, not on
# the tree, and it is what lets the tree induction step past the append the
# traversal emits: `bounded_list` matches on its first argument, so with the
# opaque `inorder(l)` in front the goal does not reduce.

def Policy.bounded_list_append(+xs: List<&2, Nat>, +ys: List<&2, Nat>, +b: Nat, +k: Bool) -> {P.bounded_list(P.append(xs, ys), b, k) == P.bounded_list(ys, b, P.bounded_list(xs, b, k)) : Bool}:
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      Policy.bounded_list_append(t, ys, b, P.and(k, P.le(h, b)))

# The transport itself, at an arbitrary decision, so that the law's step can use
# it at the decision the recursion carries. The step is three rewrites and they
# are the whole proof: the append lemma, then the induction hypothesis on the
# right subtree at the decision the left one produces, then the same on the left
# subtree. What makes it close is that the tree fold was written with the
# association the traversal has -- the alternative, an `and` of the two subtree
# answers and the key, would need associativity and commutativity first.
def Policy.bounded_transport(+t: P.Tree, +b: Nat, +k: Bool) -> {P.bounded_list(S.inorder(t), b, k) == P.bounded(t, b, k) : Bool}:
  match t:
    case P.Tip{}:
      {==}
    case P.Bin{l, key, r}:
      %Equal.sym(Bool, P.bounded_list(P.append(S.inorder(l), key <> S.inorder(r)), b, k), P.bounded_list(key <> S.inorder(r), b, P.bounded_list(S.inorder(l), b, k)), Policy.bounded_list_append(S.inorder(l), key <> S.inorder(r), b, k)) : {_ == P.bounded(r, b, P.and(P.bounded(l, b, k), P.le(key, b))) : Bool}
      %Equal.sym(Bool, P.bounded_list(S.inorder(r), b, P.and(P.bounded_list(S.inorder(l), b, k), P.le(key, b))), P.bounded(r, b, P.and(P.bounded_list(S.inorder(l), b, k), P.le(key, b))), Policy.bounded_transport(r, b, P.and(P.bounded_list(S.inorder(l), b, k), P.le(key, b)))) : {_ == P.bounded(r, b, P.and(P.bounded(l, b, k), P.le(key, b))) : Bool}
      %Equal.sym(Bool, P.bounded_list(S.inorder(l), b, k), P.bounded(l, b, k), Policy.bounded_transport(l, b, k)) : {P.bounded(r, b, P.and(_, P.le(key, b))) == P.bounded(r, b, P.and(P.bounded(l, b, k), P.le(key, b))) : Bool}
      {==}

# LAW: the premise turns the fold over the tree into the fold over the list.
# Both sides of the hypothesis are the same predicate on the two structures, so
# the transport is the only step: rewrite the goal to the tree side, then use
# the hypothesis.
def L.inorder_transport(t, b, e):
  %Equal.sym(Bool, P.bounded_list(S.inorder(t), b, True{}), P.bounded(t, b, True{}), Policy.bounded_transport(t, b, True{})) : {_ == True{} : Bool}
  %Equal.sym(Bool, P.bounded(t, b, True{}), True{}, e) : {_ == True{} : Bool}
  {==}

# LAW: the step. Definitional, because it is the reference's own unfolding --
# the two sides are the same `append` -- and what it does is pin the order.
# `inorder_transport` is a conjunction over a permutation-blind fold and
# `inorder_size` only counts, so neither of them can say where the key sits; a
# preorder-shaped body satisfies both.
def L.inorder_node(l, key, r):
  {==}

# LAW: the measure. The tree induction meets two list/number lemmas: the length
# of an append, and the successor moving out of a sum. Both are inductions of
# their own, on the list and on `Nat`, and neither is definitional -- `Nat.add`
# matches on its *left* argument, so `P.len(xs) + P.len(ys)` is stuck until the
# first is a constructor.
def Policy.len_append(+xs: List<&2, Nat>, +ys: List<&2, Nat>) -> {P.len(P.append(xs, ys)) == P.len(xs) + P.len(ys) : Nat}:
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Equal.sym(Nat, P.len(P.append(t, ys)), P.len(t) + P.len(ys), Policy.len_append(t, ys)) : {1n + _ == 1n + (P.len(t) + P.len(ys)) : Nat}
      {==}

def Policy.add_succ_right(a: Nat, +b: Nat) -> {a + (1n + b) == 1n + (a + b) : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Equal.sym(Nat, p + (1n + b), 1n + (p + b), Policy.add_succ_right(p, b)) : {1n + _ == 1n + (1n + (p + b)) : Nat}
      {==}

def L.inorder_size(t):
  match t:
    case P.Tip{}:
      {==}
    case P.Bin{l, key, r}:
      %Equal.sym(Nat, P.len(P.append(S.inorder(l), key <> S.inorder(r))), P.len(S.inorder(l)) + P.len(key <> S.inorder(r)), Policy.len_append(S.inorder(l), key <> S.inorder(r))) : {_ == P.size(P.Bin{l, key, r}) : Nat}
      %Equal.sym(Nat, P.len(S.inorder(l)), P.size(l), L.inorder_size(l)) : {_ + P.len(key <> S.inorder(r)) == P.size(P.Bin{l, key, r}) : Nat}
      %Equal.sym(Nat, P.len(S.inorder(r)), P.size(r), L.inorder_size(r)) : {P.size(l) + (1n + _) == P.size(P.Bin{l, key, r}) : Nat}
      %Equal.sym(Nat, P.size(l) + (1n + P.size(r)), 1n + (P.size(l) + P.size(r)), Policy.add_succ_right(P.size(l), P.size(r))) : {_ == 1n + (P.size(l) + P.size(r)) : Nat}
      {==}
