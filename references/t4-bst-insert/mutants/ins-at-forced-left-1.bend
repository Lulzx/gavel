import Base
import ./prelude.bend as P

# The descent takes the left branch whichever way the comparison went, so a key
# larger than the root is stored on its left. The comparison is still computed
# and passed; it is simply ignored, which type-checks.
def ins_at(t: P.Tree, c: Bool, +k: Nat) -> P.Tree:
  match t:
    case P.Tip{}:
      P.Bin{P.Tip{}, k, P.Tip{}}
    case P.Bin{+l, +key, +r}:
      match c:
        case True{}:
          P.Bin{ins_at(l, P.le(k, P.root_key(l)), k), key, r}
        case False{}:
          P.Bin{ins_at(l, P.le(k, P.root_key(l)), k), key, r}

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
      P.is_eq(key, x) + count(l, x) + count(r, x)
