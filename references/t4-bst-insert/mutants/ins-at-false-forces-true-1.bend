import Base
import ./prelude.bend as P

# The near-miss this task exists to catch. It descends the correct way at the
# node it is given, but tells the right subtree to go left unconditionally. On a
# one-node tree the answer is identical to the reference, so none of the
# definitional pins notice; the ordering is only broken one level deeper, where
# a key larger than everything in that subtree is filed to the left of a node it
# should be to the right of.
def ins_at(t: P.Tree, c: Bool, +k: Nat) -> P.Tree:
  match t:
    case P.Tip{}:
      P.Bin{P.Tip{}, k, P.Tip{}}
    case P.Bin{+l, +key, +r}:
      match c:
        case True{}:
          P.Bin{ins_at(l, P.le(k, P.root_key(l)), k), key, r}
        case False{}:
          P.Bin{l, key, ins_at(r, True{}, k)}

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
