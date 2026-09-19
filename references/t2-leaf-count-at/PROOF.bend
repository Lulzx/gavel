import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The tree is a `P.Leaf{v}` and the depth is the literal `0n`, so the outer match
# takes the leaf case and the inner match takes its empty case: both sides are
# `1n`.
def L.leaf_count_at_leaf(v):
  {==}

# The depth in the law is `1n + k`, which the inner match steps into its
# successor case, where the leaf answers `0n`.
def L.leaf_count_at_leaf_deep(v, k):
  {==}

# The tree is a `P.Node`, so the outer match takes the node case, and the depth
# `1n + k` takes the successor case, which descends into both subtrees.
def L.leaf_count_at_node_step(l, key, r, k):
  {==}

# The depth is the literal `0n` and the tree is a variable, so the case split is
# on the tree: a leaf answers `1n` and `P.is_leaf` is `True{}` there, a node
# answers `0n` and `P.is_leaf` is `False{}` there. Nothing is left over in either
# case, so no hypothesis is needed and the law is a case split rather than an
# induction.
def L.leaf_count_at_root(t):
  match t:
    case P.Leaf{v}:
      {==}
    case P.Node{l, key, r}:
      {==}

# The mirror law is the induction, and the only place arithmetic is needed. The
# mirror of a leaf is that leaf, so the leaf case is the same term on both sides.
# At a node the two sides are sums of the same two numbers in the opposite order
# -- the mirror swapped the subtrees -- so the two hypotheses replace the
# swapped readings with the originals, and `Policy.add_comm` puts the summands
# back in the order the right-hand side has them. The depth is a variable here,
# so the inner match on it is stuck and the proof splits on it as well: at `0n`
# both sides are `0n` whatever the tree is, and the successor case is the one
# the hypotheses are about.
#
# `Policy.add_comm` and the two facts it is built from are the policy's to
# write; they are under the reserved namespace, so a law never cites them.
def Policy.add_zero_right(a: Nat) -> {a == a + 0n : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_zero_right(p) : {1n + p == 1n + _ : Nat}
      {==}

def Policy.add_succ_right(a: Nat, -b: Nat) -> {a + (1n + b) == 1n + (a + b) : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_succ_right(p, b) : {1n + (p + (1n + b)) == 1n + _ : Nat}
      {==}

def Policy.add_comm(a: Nat, +b: Nat) -> {a + b == b + a : Nat}:
  match a:
    case 0n:
      %Policy.add_zero_right(b) : {b == _ : Nat}
      {==}
    case 1n+p:
      +p = p
      %Equal.sym(Nat, b + (1n + p), 1n + (b + p), Policy.add_succ_right(b, p)) :
          {1n + (p + b) == _ : Nat}
      %Policy.add_comm(p, b) : {1n + (p + b) == 1n + _ : Nat}
      {==}

def L.leaf_count_at_mirror(t, k):
  match t:
    case P.Leaf{v}:
      {==}
    case P.Node{+l, key, +r}:
      match k:
        case 0n:
          {==}
        case 1n++kp:
          %Equal.sym(Nat, S.leaf_count_at(P.mirror(r), kp), S.leaf_count_at(r, kp), L.leaf_count_at_mirror(r, kp)) : {_ + S.leaf_count_at(P.mirror(l), kp) == S.leaf_count_at(l, kp) + S.leaf_count_at(r, kp) : Nat}
          %Equal.sym(Nat, S.leaf_count_at(P.mirror(l), kp), S.leaf_count_at(l, kp), L.leaf_count_at_mirror(l, kp)) : {S.leaf_count_at(r, kp) + _ == S.leaf_count_at(l, kp) + S.leaf_count_at(r, kp) : Nat}
          %Equal.sym(Nat, S.leaf_count_at(r, kp) + S.leaf_count_at(l, kp), S.leaf_count_at(l, kp) + S.leaf_count_at(r, kp), Policy.add_comm(S.leaf_count_at(r, kp), S.leaf_count_at(l, kp))) : {_ == S.leaf_count_at(l, kp) + S.leaf_count_at(r, kp) : Nat}
          {==}
