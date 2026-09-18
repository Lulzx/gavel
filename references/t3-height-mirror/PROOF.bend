import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The two facts about `P.max` that `height_mirror` needs. `max` steps on its
# first argument and then on its second, so on variables neither side reduces
# and the commutation is an induction on the first argument with a case split on
# the second.
def Policy.max_comm(a: Nat, +b: Nat) -> {P.max(a, b) == P.max(b, a) : Nat}:
  match a:
    case 0n:
      match b:
        case 0n:
          {==}
        case 1n+q:
          {==}
    case 1n+p:
      match b:
        case 0n:
          {==}
        case 1n+q:
          %Policy.max_comm(p, q) : {1n + P.max(p, q) == 1n + _ : Nat}
          {==}

def L.height_leaf():
  {==}

def L.height_node(l, r):
  {==}

# The step replaces each subtree's height with the original's and is left with
# the two heights in the other order under the same `1n +`.
def L.height_mirror(t):
  match t:
    case P.Leaf{}:
      {==}
    case P.Node{l, r}:
      %Equal.sym(Nat, S.height(P.mirror(r)), S.height(r), L.height_mirror(r))
          : {1n + P.max(_, S.height(P.mirror(l))) == 1n + P.max(S.height(l), S.height(r)) : Nat}
      %Equal.sym(Nat, S.height(P.mirror(l)), S.height(l), L.height_mirror(l))
          : {1n + P.max(S.height(r), _) == 1n + P.max(S.height(l), S.height(r)) : Nat}
      %Policy.max_comm(S.height(r), S.height(l))
          : {1n + P.max(S.height(r), S.height(l)) == 1n + _ : Nat}
      {==}
