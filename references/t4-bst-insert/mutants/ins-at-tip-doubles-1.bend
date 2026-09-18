import Base
import ./prelude.bend as P

# Inserting into a leaf stores the key twice, in a node that also holds a copy
# of itself. The result is ordered -- both copies are equal to the key above
# them -- so only the count rejects it.
def ins_at(t: P.Tree, c: Bool, +k: Nat) -> P.Tree:
  match t:
    case P.Tip{}:
      P.Bin{P.Bin{P.Tip{}, k, P.Tip{}}, k, P.Tip{}}
    case P.Bin{+l, +key, +r}:
      match c:
        case True{}:
          P.Bin{ins_at(l, P.le(k, P.root_key(l)), k), key, r}
        case False{}:
          P.Bin{l, key, ins_at(r, P.le(k, P.root_key(r)), k)}

def insert(t: P.Tree, +k: Nat) -> P.Tree:
  match t:
    case P.Tip{}:
      P.Bin{P.Bin{P.Tip{}, k, P.Tip{}}, k, P.Tip{}}
    case P.Bin{+l, +key, +r}:
      ins_at(P.Bin{l, key, r}, P.le(k, key), k)

def count(t: P.Tree, +x: Nat) -> Nat:
  match t:
    case P.Tip{}:
      0n
    case P.Bin{+l, +key, +r}:
      P.is_eq(key, x) + count(l, x) + count(r, x)
