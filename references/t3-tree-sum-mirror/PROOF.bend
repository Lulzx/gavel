import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The arithmetic that `tree_sum_mirror` needs. `Nat.add` folds on its first
# argument, so `a + 0n` is stuck on a variable, `a + b` does not commute, and
# `a + b + c` does not reassociate on its own. These are the same three facts
# the bank's other arithmetic tasks use.
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
      %Equal.sym(Nat, b + (1n + p), 1n + (b + p), Policy.add_succ_right(b, p)) :
          {1n + (p + b) == _ : Nat}
      %Policy.add_comm(p, b) : {1n + (p + b) == 1n + _ : Nat}
      {==}

def L.tree_sum_leaf():
  {==}

def L.tree_sum_node(l, key, r):
  {==}

# The step replaces each subtree's sum with the original's and is left with the
# two sums swapped around the key: `(s + key) + u` against `(u + key) + s`. Four
# rewrites take one side to the other, and the last one is the goal itself.
def L.tree_sum_mirror(t):
  match t:
    case P.Leaf{}:
      {==}
    case P.Node{l, key, r}:
      %Equal.sym(Nat, S.tree_sum(P.mirror(r)), S.tree_sum(r), L.tree_sum_mirror(r))
          : {(_ + key) + S.tree_sum(P.mirror(l)) == (S.tree_sum(l) + key) + S.tree_sum(r) : Nat}
      %Equal.sym(Nat, S.tree_sum(P.mirror(l)), S.tree_sum(l), L.tree_sum_mirror(l))
          : {(S.tree_sum(r) + key) + _ == (S.tree_sum(l) + key) + S.tree_sum(r) : Nat}
      %Equal.sym(Nat, S.tree_sum(l) + key, key + S.tree_sum(l), Policy.add_comm(S.tree_sum(l), key))
          : {(S.tree_sum(r) + key) + S.tree_sum(l) == _ + S.tree_sum(r) : Nat}
      %Policy.add_assoc(S.tree_sum(r), key, S.tree_sum(l))
          : {_ == (key + S.tree_sum(l)) + S.tree_sum(r) : Nat}
      Policy.add_comm(S.tree_sum(r), key + S.tree_sum(l))
