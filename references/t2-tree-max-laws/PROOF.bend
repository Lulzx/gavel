import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `tree_max` steps on the constructor and reads nothing else, so both pins are
# definitional: at a leaf both sides are the number the leaf carries, and at a
# node both sides are `P.max` of the two recursive answers.
def L.tree_max_leaf(v):
  {==}

def L.tree_max_node(l, r):
  {==}

# The content law needs three arithmetic facts about `P.max`, all of them the
# policy's, because `P.max` steps on its first argument and then on its second,
# so on variables neither side reduces.
#
# The first is `x` against `max x 0n`. `P.max`'s first argument decides the
# outer match, so on `0n` it returns the second argument and on `1n+p` it takes
# the second match, which on `0n` returns `1n+p` -- both sides compute without
# an induction.
def Policy.max_zero(x: Nat) -> {x == P.max(x, 0n) : Nat}:
  match x:
    case 0n:
      {==}
    case 1n+p:
      {==}

# The second is associativity. The outer match is on `a`, and in the `1n+p`
# branch neither `P.max(1n+p, b)` nor `P.max(b, c)` reduces while `b` and `c`
# are variables, so the branch splits on `b` and then on `c`. The one branch
# that needs work is `b = 1n+q` and `c = 1n+r`, where both sides are
# `1n +` a nested `P.max` and the induction hypothesis at `(p, q, r)` is the
# step. It is used flipped -- the hypothesis reads left-nested to right-nested
# and the goal has left-nested on the left -- so it is reached through
# `Equal.sym`, whose equation points the way the rewrite has to go.
def Policy.max_assoc(a: Nat, +b: Nat, +c: Nat) -> {P.max(P.max(a, b), c) == P.max(a, P.max(b, c)) : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      match b:
        case 0n:
          {==}
        case 1n+q:
          match c:
            case 0n:
              {==}
            case 1n+r:
              %Equal.sym(Nat, P.max(P.max(p, q), r), P.max(p, P.max(q, r)), Policy.max_assoc(p, q, r))
                  : {1n + _ == 1n + P.max(p, P.max(q, r)) : Nat}
              {==}

# The third is the one the tree induction lands on: the largest of `xs`
# appended to `ys` is the larger of their largest. It is an induction on the
# list. The empty case is definitional because `P.max_all` on `Nil{}` is `0n`
# and `P.max(x, 0n)` on the first argument returns `x`. The cons case appends
# the two readings left-nested against right-nested, which is exactly
# `Policy.max_assoc` -- on the right there is a `P.max(h, _)` to rewrite, and
# on the left the head is already at the top of a left-nested tower. Both
# binders are `+`: the motive reads `t` and the recursive call consumes it, and
# the motive reads `h` while the unfolding consumes it.
def Policy.max_all_append(xs: List<&2, Nat>, +ys: List<&2, Nat>) -> {P.max(P.max_all(xs), P.max_all(ys)) == P.max_all(P.append(xs, ys)) : Nat}:
  match xs:
    case Nil{}:
      {==}
    case +h <> +t:
      %Policy.max_all_append(t, ys) : {P.max(P.max(h, P.max_all(t)), P.max_all(ys)) == P.max(h, _) : Nat}
      %Policy.max_assoc(h, P.max_all(t), P.max_all(ys)) : {P.max(P.max(h, P.max_all(t)), P.max_all(ys)) == _ : Nat}
      {==}

# The induction is in the tree. At a leaf the right-hand side is a one-element
# list, whose largest is the leaf's own number -- `Policy.max_zero` under
# `P.max` at the top of the tower. At a node both sides read the two subtrees
# and combine the readings: `Policy.max_all_append` turns the appended list into
# the nested `P.max` the hypotheses need, and then the two hypotheses, one per
# subtree, put both sides on the same term.
def L.tree_max_flatten(t):
  match t:
    case P.Leaf{v}:
      %Policy.max_zero(v) : {v == _ : Nat}
      {==}
    case P.Node{+l, +r}:
      %Policy.max_all_append(P.flatten(l), P.flatten(r)) : {P.max(S.tree_max(l), S.tree_max(r)) == _ : Nat}
      %L.tree_max_flatten(l) : {P.max(S.tree_max(l), S.tree_max(r)) == P.max(_, P.max_all(P.flatten(r))) : Nat}
      %L.tree_max_flatten(r) : {P.max(S.tree_max(l), S.tree_max(r)) == P.max(S.tree_max(l), _) : Nat}
      {==}
