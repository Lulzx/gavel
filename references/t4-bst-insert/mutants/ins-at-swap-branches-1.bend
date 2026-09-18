import Base
import ./prelude.bend as P

# The two branches are exchanged: `True` (the key is at most the node's) descends
# right and `False` descends left. Every recursive call still shrinks, and the
# comparison is still the one computed at this node, so it type-checks.
def ins_at(t: P.Tree, c: Bool, +k: Nat) -> P.Tree:
  match t:
    case P.Tip{}:
      P.Bin{P.Tip{}, k, P.Tip{}}
    case P.Bin{+l, +key, +r}:
      match c:
        case True{}:
          P.Bin{l, key, ins_at(r, P.le(k, P.root_key(r)), k)}
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
