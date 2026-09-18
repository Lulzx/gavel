import Base
import ./prelude.bend as P

# The count reads only the right subtree and the node's own key: everything
# stored to the left is invisible. It still returns `0n` at a leaf and still adds
# indicators, so only an insert that lands on the left tells the two apart.
def ins_at(t: P.Tree, c: Bool, +k: Nat) -> P.Tree:
  match t:
    case P.Tip{}:
      P.Bin{P.Tip{}, k, P.Tip{}}
    case P.Bin{+l, +key, +r}:
      match c:
        case True{}:
          P.Bin{ins_at(l, P.le(k, P.root_key(l)), k), key, r}
        case False{}:
          P.Bin{l, key, ins_at(r, P.le(k, P.root_key(r)), k)}

def insert(t: P.Tree, +k: Nat) -> P.Tree:
  match t:
    case P.Tip{}:
      P.Bin{P.Tip{}, k, P.Tip{}}
    case P.Bin{+l, +key, +r}:
      ins_at(P.Bin{l, key, r}, P.le(k, key), k)

def count(t: P.Tree, +x: Nat) -> Nat:
  match t:
    case P.Tip{}:
      0n
    case P.Bin{+l, +key, +r}:
      P.is_eq(key, x) + count(r, x)
