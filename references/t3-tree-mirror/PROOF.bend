import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `Nat.add` folds on its first argument, so `a + 0n` is stuck on a variable and
# `a + b` does not commute on its own. `mirror_size` needs the commutativity;
# the other three are what it takes to state it.
def Policy.add_zero_right(a: Nat) -> {a == a + 0n : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_zero_right(p) : {1n + p == 1n + _ : Nat}
      {==}

def Policy.add_assoc(a: Nat, -b: Nat, -c: Nat) -> {a + (b + c) == (a + b) + c : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_assoc(p, b, c) : {1n + (p + (b + c)) == 1n + _ : Nat}
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

# Both subtrees are live twice in the step: once as the recursive call that the
# hypothesis replaces, and once in the tree that is left as the goal. That is
# the `+t` on the law; without it the second use of `l` or `r` is a Lone
# violation.
def L.mirror_mirror(t):
  match t:
    case P.Leaf{v}:
      {==}
    case P.Node{l, r}:
      %Equal.sym(P.Tree, S.mirror(S.mirror(l)), l, L.mirror_mirror(l)) : {P.Node{_, S.mirror(S.mirror(r))} == P.Node{l, r} : P.Tree}
      %Equal.sym(P.Tree, S.mirror(S.mirror(r)), r, L.mirror_mirror(r)) : {P.Node{l, _} == P.Node{l, r} : P.Tree}
      {==}

# Only the left subtree is live: `rightmost` and `leftmost` each descend one
# side, so the goal after unfolding is the hypothesis itself at `l`.
def L.mirror_leftmost(t):
  match t:
    case P.Leaf{v}:
      {==}
    case P.Node{l, r}:
      L.mirror_leftmost(l)

def L.mirror_rightmost(t):
  match t:
    case P.Leaf{v}:
      {==}
    case P.Node{l, r}:
      L.mirror_rightmost(r)

# The step replaces both subtrees with the hypotheses and is left with the sum
# of the two sizes in the other order.
def L.mirror_size(t):
  match t:
    case P.Leaf{v}:
      {==}
    case P.Node{l, r}:
      %Equal.sym(Nat, P.size(S.mirror(r)), P.size(r), L.mirror_size(r)) : {_ + P.size(S.mirror(l)) == P.size(l) + P.size(r) : Nat}
      %Equal.sym(Nat, P.size(S.mirror(l)), P.size(l), L.mirror_size(l)) : {P.size(r) + _ == P.size(l) + P.size(r) : Nat}
      Policy.add_comm(P.size(r), P.size(l))
