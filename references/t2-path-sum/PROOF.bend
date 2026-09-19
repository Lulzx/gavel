import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The tree is a `P.Leaf`, so the match takes the leaf case, which answers the
# value it carries: both sides are `v`.
def L.path_sum_leaf(v):
  {==}

# The tree is a `P.Node`, so the match takes the node case: the two sides are
# the same term, with the node's key multiplied by the same prelude count.
def L.path_sum_node(l, key, r):
  {==}

# The tree is closed, so the match reduces: the root's two subtrees are leaves
# answering `1n` and `3n`, each leaf count is `1n`, and the key `2n` is
# multiplied by their sum. What is left is the numeral `8n` on both sides.
def L.path_sum_three():
  {==}

# The same, one level down: the inner node's answer, the third leaf's value, and
# the root's key multiplied by three leaves. What is left is the numeral `27n`
# on both sides.
def L.path_sum_deep():
  {==}

# The induction is in `t`. At a leaf `P.zeroed` answers a leaf carrying zero and
# the walk answers that zero. At a node the walk's own step is visible: the two
# subtrees' answers are replaced by the hypotheses, and the key's contribution
# vanishes because `P.zeroed` handed the node a zero key and `Nat.mul` of `0n`
# is `0n` whatever it is multiplied by.
def L.path_sum_zeroed(t):
  match t:
    case P.Leaf{v}:
      {==}
    case P.Node{+l, key, +r}:
      %Equal.sym(Nat, S.path_sum(P.zeroed(l)), 0n, L.path_sum_zeroed(l)) : {Nat.add(Nat.add(_, S.path_sum(P.zeroed(r))), 0n) == 0n : Nat}
      %Equal.sym(Nat, S.path_sum(P.zeroed(r)), 0n, L.path_sum_zeroed(r)) : {Nat.add(Nat.add(0n, _), 0n) == 0n : Nat}
      {==}
